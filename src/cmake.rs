use std::ffi::OsString;
use std::fs;
use zed::LanguageServerId;
use zed_extension_api::{self as zed, serde_json, Result};

struct NeoCMakeExt {
    cached_binary_path: Option<String>,
}

impl NeoCMakeExt {
    fn binary_name() -> &'static str {
        let (platform, _) = zed::current_platform();
        match platform {
            zed::Os::Linux | zed::Os::Mac => "neocmakelsp",
            zed::Os::Windows => "neocmakelsp.exe",
        }
    }

    fn asset_name() -> Result<&'static str> {
        let (platform, arch) = zed::current_platform();
        match (platform, arch) {
            (zed::Os::Mac, _) => Ok("neocmakelsp-universal-apple-darwin.tar.gz"),
            (zed::Os::Windows, zed::Architecture::Aarch64) => {
                Ok("neocmakelsp-aarch64-pc-windows-msvc.zip")
            }
            (zed::Os::Windows, zed::Architecture::X8664) => {
                Ok("neocmakelsp-x86_64-pc-windows-msvc.zip")
            }
            (zed::Os::Linux, zed::Architecture::Aarch64) => {
                Ok("neocmakelsp-aarch64-unknown-linux-gnu.tar.gz")
            }
            (zed::Os::Linux, zed::Architecture::X8664) => {
                Ok("neocmakelsp-x86_64-unknown-linux-gnu.tar.gz")
            }
            _ => Err(format!(
                "Unsupported platform-arch combination: {:?} {:?}",
                platform, arch
            )),
        }
    }

    fn asset_type() -> zed::DownloadedFileType {
        let (platform, _) = zed::current_platform();
        match platform {
            zed::Os::Mac | zed::Os::Linux => zed::DownloadedFileType::GzipTar,
            zed::Os::Windows => zed::DownloadedFileType::Zip,
        }
    }

    fn latest_release(language_server_id: &LanguageServerId) -> Result<String> {
        zed::set_language_server_installation_status(
            language_server_id,
            &zed::LanguageServerInstallationStatus::CheckingForUpdate,
        );

        let release = zed::latest_github_release(
            "neocmakelsp/neocmakelsp",
            zed::GithubReleaseOptions {
                require_assets: true,
                pre_release: false,
            },
        )?;
        let asset_name = NeoCMakeExt::asset_name()?;
        let asset = release
            .assets
            .iter()
            .find(|asset| asset.name == asset_name)
            .ok_or_else(|| format!("No asset found matching {:?}", asset_name))?;

        let version_dir = format!("neocmakelsp-{}", release.version);
        let binary_path = format!("{version_dir}/{}", NeoCMakeExt::binary_name());
        if !fs::metadata(&binary_path).map_or(false, |stat| stat.is_file()) {
            zed::set_language_server_installation_status(
                language_server_id,
                &zed::LanguageServerInstallationStatus::Downloading,
            );

            zed::download_file(&asset.download_url, &version_dir, NeoCMakeExt::asset_type())
                .map_err(|e| format!("Failed to download file: {e}"))?;
            zed::make_file_executable(&binary_path)?;
        }

        zed::set_language_server_installation_status(
            language_server_id,
            &zed::LanguageServerInstallationStatus::None,
        );

        Ok(binary_path)
    }

    fn clean(keep: &str) -> Result<()> {
        let keep_dir = keep.split('/').next().ok_or("Failed to split keep path")?;
        let entries =
            fs::read_dir(".").map_err(|e| format!("Failed to list working directory {e}"))?;
        for entry in entries {
            let entry = entry.map_err(|e| format!("Failed to load directory entry {e}"))?;
            if entry.file_name().to_str() != Some(&keep_dir) {
                fs::remove_dir_all(entry.path()).ok();
            }
        }
        Ok(())
    }

    fn clean_pop() -> Result<String> {
        let mut entries: Vec<OsString> = fs::read_dir(".")
            .map_err(|e| format!("Failed to list working directory: {e}"))?
            .filter_map(|e| e.ok())
            .map(|e| e.file_name())
            .collect();

        entries.sort();

        let newest = entries
            .pop()
            .and_then(|e| e.into_string().ok())
            .ok_or("No versions found")?;

        entries.iter().for_each(|e| {
            fs::remove_dir_all(e).ok();
        });

        Ok(format!("{newest}/{}", NeoCMakeExt::binary_name()))
    }

    fn update_binary_path(&mut self, language_server_id: &LanguageServerId) -> Option<String> {
        let binary_path = match NeoCMakeExt::latest_release(language_server_id) {
            Ok(binary_path) => {
                NeoCMakeExt::clean(binary_path.as_str()).map_err(|e| println!("{}", e));
                Some(binary_path)
            }
            Err(e) => {
                println!("{}", e);
                match NeoCMakeExt::clean_pop() {
                    Ok(binary_path) => Some(binary_path),
                    Err(e) => {
                        println!("{}", e);
                        zed::set_language_server_installation_status(
                            language_server_id,
                            &zed::LanguageServerInstallationStatus::Failed(
                                "Could not update binary path. See logs for more info".to_string(),
                            ),
                        );
                        None
                    }
                }
            }
        };
        self.cached_binary_path = binary_path.clone();
        return binary_path;
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
        if let Some(binary) = worktree
            .which(NeoCMakeExt::binary_name())
            .or_else(|| self.cached_binary_path.clone())
            .or_else(|| self.update_binary_path())
        {
            Ok(zed::Command {
                command: binary,
                args: vec![String::from("stdio")],
                env: Default::default(),
            })
        }
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
