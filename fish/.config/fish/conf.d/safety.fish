# safety.fish — guardrails for interactive fish sessions
#
# Install: either
#   1. save as ~/.config/fish/conf.d/safety.fish (auto-loaded), or
#   2. save anywhere and add `source /path/to/safety.fish` to config.fish, or
#   3. paste the contents into config.fish.
#
# Requires fish 3.5+ (uses `path resolve`).
# Bypass any wrapper once with:  command rm ...

status is-interactive; or return

# ---------------------------------------------------------------------------
# Helper: ask for confirmation. Returns 0 only on "y" / "yes".
# ---------------------------------------------------------------------------
function __safety_confirm --argument-names prompt
    read -l -P "$prompt [y/N] " ans
    string match -qir '^y(es)?$' -- "$ans"
end

# ---------------------------------------------------------------------------
# GNU vs BSD detection (GNU coreutils has --version, BSD/macOS does not)
# ---------------------------------------------------------------------------
if command rm --version >/dev/null 2>&1
    set -g __safety_gnu 1
    set -g __safety_rm_flag -I   # prompt once for >3 files or recursive deletes
else
    set -g __safety_gnu 0
    set -g __safety_rm_flag -i   # prompt for every file
end

# ---------------------------------------------------------------------------
# rm: refuse critical paths, then prompt before deleting
# ---------------------------------------------------------------------------
function rm --description 'rm with protected-path check and prompt'
    set -l protected / /bin /boot /dev /etc /lib /lib64 /opt /proc /root /sbin \
        /sys /usr /var /home /Users /System /Library /Applications /private $HOME

    for arg in $argv
        string match -q -- '-*' $arg; and continue
        set -l resolved (path resolve -- $arg)
        if contains -- $resolved $protected
            echo "rm: refusing to remove protected path: $resolved" >&2
            return 1
        end
    end

    command rm $__safety_rm_flag $argv
end

# ---------------------------------------------------------------------------
# Prompt before overwriting
# ---------------------------------------------------------------------------
alias cp 'cp -i'
alias mv 'mv -i'
alias ln 'ln -i'

# ---------------------------------------------------------------------------
# GNU only: never recurse on "/" with chmod/chown/chgrp
# ---------------------------------------------------------------------------
if test $__safety_gnu -eq 1
    alias chmod 'chmod --preserve-root'
    alias chown 'chown --preserve-root'
    alias chgrp 'chgrp --preserve-root'
end

# ---------------------------------------------------------------------------
# dd: confirm before writing to a raw device
# ---------------------------------------------------------------------------
function dd --description 'dd with confirmation when writing to /dev/*'
    if string match -qr '(^| )of=/dev/' -- "$argv"
        __safety_confirm "dd is writing to a device ($argv). Continue?"; or return 1
    end
    command dd $argv
end

# ---------------------------------------------------------------------------
# Confirm before reboot / shutdown (handy over SSH)
# ---------------------------------------------------------------------------
for cmd in reboot poweroff halt shutdown
    if command -q $cmd
        function $cmd --inherit-variable cmd --description "$cmd with confirmation"
            __safety_confirm "Really run '$cmd $argv'?"; or return 1
            command $cmd $argv
        end
    end
end

# NOTE: `sudo rm ...`, `sudo dd ...` etc. skip these wrappers, because sudo runs
# the real binaries and doesn't see fish functions or aliases.
