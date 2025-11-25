use std::fs;
use zed::LanguageServerId;
use zed_extension_api::{self as zed, Result};

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
        let binary_path = format!(
            "{version_dir}/neocmakelsp{}",
            match platform {
                zed::Os::Mac | zed::Os::Linux => "",
                zed::Os::Windows => ".exe",
            }
        );

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
}

zed::register_extension!(NeoCMakeExt);
