use std::fs;
use zed::LanguageServerId;
use zed_extension_api::{self as zed, Result};

struct NeoCMakeExt {
    cached_binary_path: Option<String>,
}

impl NeoCMakeExt {
    // Detect musl-based Linux
    fn is_musl() -> bool {
        fs::read_to_string("/usr/bin/ldd")
            .map(|s| s.contains("musl"))
            .unwrap_or(false)
    }

    fn asset_name(platform: zed::Os, arch: zed::Architecture) -> Result<String> {
        match platform {
            zed::Os::Mac => {
                // Only one macOS build exists, universal
                return Ok("neocmakelsp-universal-apple-darwin.tar.gz".into());
            }

            zed::Os::Windows => {
                let arch_str = match arch {
                    zed::Architecture::Aarch64 => "aarch64",
                    zed::Architecture::X8664 => "x86_64",
                    _ => return Err("Unsupported Windows architecture".into()),
                };
                return Ok(format!("neocmakelsp-{arch_str}-pc-windows-msvc.zip"));
            }

            zed::Os::Linux => {
                let arch_str = match arch {
                    zed::Architecture::Aarch64 => "aarch64",
                    zed::Architecture::X8664 => "x86_64",
                    _ => return Err("Unsupported Linux architecture".into()),
                };

                let libc_suffix = if Self::is_musl() {
                    "unknown-linux-musl.tar.gz"
                } else {
                    "unknown-linux-gnu.tar.gz"
                };

                return Ok(format!("neocmakelsp-{arch_str}-{libc_suffix}"));
            }
        }
    }

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

        zed::set_language_server_installation_status(
            &language_server_id,
            &zed::LanguageServerInstallationStatus::CheckingForUpdate,
        );
        let release = zed::latest_github_release(
            "Decodetalkers/neocmakelsp",
            zed::GithubReleaseOptions {
                require_assets: true,
                pre_release: false,
            },
        )?;

        let (platform, arch) = zed::current_platform();
        let asset_name = Self::asset_name(platform, arch)?;

        let asset = release
            .assets
            .iter()
            .find(|asset| asset.name == asset_name)
            .ok_or_else(|| format!("no asset found matching {:?}", asset_name))?;

        let binary_path = format!(
            "neocmakelsp{ext}",
            ext = match platform {
                zed::Os::Mac | zed::Os::Linux => "",
                zed::Os::Windows => ".exe",
            }
        );

        if !fs::metadata(&binary_path).map_or(false, |stat| stat.is_file()) {
            zed::set_language_server_installation_status(
                &language_server_id,
                &zed::LanguageServerInstallationStatus::Downloading,
            );

            let file_type = if platform == zed::Os::Windows {
                zed::DownloadedFileType::Zip
            } else {
                zed::DownloadedFileType::GzipTar
            };

            zed::download_file(&asset.download_url, &binary_path, file_type)
                .map_err(|e| format!("failed to download file: {e}"))?;
        }

        // Clean up old LSP versions
        let entries =
            fs::read_dir(".").map_err(|e| format!("failed to list working directory {e}"))?;
        for entry in entries {
            let entry = entry.map_err(|e| format!("failed to load directory entry {e}"))?;
            if entry.file_name().to_str() != Some(&binary_path) {
                fs::remove_dir_all(&entry.path()).ok();
            }
        }

        zed::make_file_executable(&binary_path)?;

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
}

zed::register_extension!(NeoCMakeExt);
