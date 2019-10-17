
userName=$(whoami)

echo "File name: "
read file

if [ -f $file ]; then

    if [ -d tempChange ]; then
        cp $file tempChange
    else
        mkdir tempChange && cp $file tempChange
    fi

    nano $file
    while [ -n "`pgrep nano`"  ]; do :; done

    if [ -d log ]; then
        diff -c $file tempChange/$file > log/"${file}-${username}-edit-x"
    else
        mkdir log && diff -c $file tempChange/$file > log/"${file}-${username}-edit-x"
    fi
    
    echo "Complete"

else
    echo "File does not exist"
fi





