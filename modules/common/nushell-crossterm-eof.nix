{ ... }:

let
  nushellPtyEofJobCleanupPatch = builtins.toFile "nushell-pty-eof-job-cleanup.patch" ''
    diff --git a/crates/nu-engine/src/exit.rs b/crates/nu-engine/src/exit.rs
    --- a/crates/nu-engine/src/exit.rs
    +++ b/crates/nu-engine/src/exit.rs
    @@ -1,6 +1,7 @@
     use std::sync::atomic::Ordering;
     
     use nu_protocol::engine::EngineState;
    +use nu_utils::stdout_write_all_and_flush;
     
     /// Exit the process or clean jobs if appropriate.
     ///
    @@ -32,14 +33,17 @@ pub fn cleanup<T>(tag: T, engine_state: &EngineState) -> Option<T> {
         {
             let job_count = jobs.iter().count();
     
    -        println!("There are still background jobs running ({job_count}).");
    -
    -        println!("Running `exit` a second time will kill all of them.");
    -
             engine_state
                 .exit_warning_given
                 .store(true, Ordering::SeqCst);
     
    +        // The terminal may have disconnected while jobs are still running. Avoid
    +        // panicking on a broken stdout so the next cleanup attempt can kill them.
    +        let _ = stdout_write_all_and_flush(format!(
    +            "There are still background jobs running ({job_count}).\n\
    +             Running `exit` a second time will kill all of them.\n"
    +        ));
    +
             return Some(tag);
         }
     
  '';
in
{
  nixpkgs.overlays = [
    (
      _: prev:
      prev.lib.optionalAttrs prev.stdenv.hostPlatform.isDarwin {
        nushell = prev.nushell.overrideAttrs (old: {
          prePatch = (old.prePatch or "") + ''
            patch -p1 < ${nushellPtyEofJobCleanupPatch}

            crossterm_dir="$cargoDepsCopy/source-registry-0/crossterm-0.29.0"
            crossterm_tty="$crossterm_dir/src/event/source/unix/tty.rs"
            sed -i 's/\r$//' "$crossterm_tty"
            patch -d "$crossterm_dir" -p1 \
                < ${../../patches/crossterm-0.29.0-pty-eof.patch}
          '';
        });
      }
    )
  ];
}
