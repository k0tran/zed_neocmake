use std::fs;
use zed::LanguageServerId;
use zed_extension_api::{self as zed, serde_json, Result};

struct NeoCMakeExt {
    cached_binary_path: Option<String>,
}

impl NeoCMakeExt {
    fn language_server_binary_path(
        &mut self,
        language_server_id: &LanguageServerId,
        worktree: &zed::Worktree,
    ) -> Result<String> {
        if let Some(path) = worktree.which("neocmakelsp") {
            return Ok(path);
        }

        if let Some(path) = &self.cached_binary_path {
            if fs::metadata(path).map_or(false, |stat| stat.is_file()) {
                return Ok(path.clone());
            }
        }

        let (platform, arch) = zed::current_platform();
        let exe_suffix = match platform {
            zed::Os::Windows => ".exe",
            _ => "",
        };

        zed::set_language_server_installation_status(
            &language_server_id,
            &zed::LanguageServerInstallationStatus::CheckingForUpdate,
        );

        let release = zed::latest_github_release(
            "neocmakelsp/neocmakelsp",
            zed::GithubReleaseOptions {
                require_assets: true,
                pre_release: false,
            },
        );

        let release = match release {
            Ok(release) => release,
            Err(e) => {
                eprintln!("neocmakelsp: GitHub unreachable ({e}), looking for cached binary");
                return {
                    let dir = fs::read_dir(".")
                        .map_err(|err| {
                            format!("GitHub unreachable ({e}) and failed to list directory: {err}")
                        })?
                        .flatten()
                        .map(|e| e.path())
                        .find(|p| {
                            p.is_dir()
                                && p.file_name()
                                    .and_then(|n| n.to_str())
                                    .map_or(false, |n| n.starts_with("neocmakelsp-"))
                        })
                        .ok_or_else(|| {
                            format!("GitHub unreachable and no cached directory found: {e}")
                        })?;

                    let binary = dir.join(format!("neocmakelsp{exe_suffix}"));
                    if fs::metadata(&binary).map_or(false, |m| m.is_file()) {
                        let path = binary.to_string_lossy().to_string();
                        self.cached_binary_path = Some(path.clone());
                        Ok(path)
                    } else {
                        Err(format!("Cached directory found but binary missing: {e}"))
                    }
                };
            }
        };

        let asset_name = match (platform, arch) {
            (zed::Os::Mac, _) => "neocmakelsp-universal-apple-darwin.tar.gz",
            (zed::Os::Windows, zed::Architecture::Aarch64) => {
                "neocmakelsp-aarch64-pc-windows-msvc.zip"
            }
            (zed::Os::Windows, zed::Architecture::X8664) => {
                "neocmakelsp-x86_64-pc-windows-msvc.zip"
            }
            (zed::Os::Linux, zed::Architecture::Aarch64) => {
                "neocmakelsp-aarch64-unknown-linux-gnu.tar.gz"
            }
            (zed::Os::Linux, zed::Architecture::X8664) => {
                "neocmakelsp-x86_64-unknown-linux-gnu.tar.gz"
            }
            _ => {
                return Err(format!(
                    "Unsupported platform-arch combination: {:?} {:?}",
                    platform, arch
                ))
            }
        };
        let asset_type = match platform {
            zed::Os::Mac | zed::Os::Linux => zed::DownloadedFileType::GzipTar,
            zed::Os::Windows => zed::DownloadedFileType::Zip,
        };

        let asset = release
            .assets
            .iter()
            .find(|asset| asset.name == asset_name)
            .ok_or_else(|| format!("no asset found matching {:?}", asset_name))?;

        let version_dir = format!("neocmakelsp-{}", release.version);
        let binary_path = format!("{version_dir}/neocmakelsp{exe_suffix}"); // Line 65 moment

        if !fs::metadata(&binary_path).map_or(false, |stat| stat.is_file()) {
            zed::set_language_server_installation_status(
                &language_server_id,
                &zed::LanguageServerInstallationStatus::Downloading,
            );

            zed::download_file(&asset.download_url, &version_dir, asset_type)
                .map_err(|e| format!("failed to download file: {e}"))?;

            zed::make_file_executable(&binary_path)?;

            // Remove old versions
            let entries =
                fs::read_dir(".").map_err(|e| format!("failed to list working directory {e}"))?;
            for entry in entries {
                let entry = entry.map_err(|e| format!("failed to load directory entry {e}"))?;
                if entry.file_name().to_str() != Some(&version_dir) {
                    fs::remove_dir_all(entry.path()).ok();
                }
            }
        }

        self.cached_binary_path = Some(binary_path.clone());
        Ok(binary_path)
    }
}

impl zed::Extension for NeoCMakeExt {
    fn new() -> Self {
        Self {
            cached_binary_path: None,
        }
    }

    fn language_server_command(
        &mut self,
        language_server_id: &LanguageServerId,
        worktree: &zed::Worktree,
    ) -> Result<zed::Command> {
        Ok(zed::Command {
            command: self.language_server_binary_path(language_server_id, worktree)?,
            args: vec![String::from("stdio")],
            env: Default::default(),
        })
    }

    fn language_server_initialization_options(
        &mut self,
        _language_server_id: &LanguageServerId,
        _worktree: &zed::Worktree,
    ) -> Result<Option<serde_json::Value>> {
        Ok(Some(serde_json::json!({
            "format": { "enable": true },
            "lint": { "enable": true },
            "scan_cmake_in_package": false,
            "semantic_token": false
        })))
    }
}

zed::register_extension!(NeoCMakeExt);
