# https://wiki.archlinux.org/index.php/Bash/Prompt_customization#Colors

# standard colors
for C in {30..37}; do
    echo -en "\e[${C}m$C "
done
# high intensity colors
for C in {90..97}; do
    echo -en "\e[${C}m$C "
done
# 256 colors
for C in {16..255}; do
    echo -en "\e[38;5;${C}m$C "
done
echo -e "\e(B\e[m"
