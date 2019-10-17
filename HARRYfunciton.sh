
username=$(whoami)
echo "---Avaliable Files---"
#Figure out a way to only show .txt files? or csv or whatever the files we need to be able to edit are
ls
echo "Enter the file name of the file you wish to edit: "
read fileName

if [ -f $fileName ]; then

    #Also figure out how to store these, maybe in directories with the date / time as their name?
    if [ -d olderVersion ]; then
        cp $fileName olderVersion
    else
        mkdir olderVersion && cp $fileName olderVersion
    fi

    mkdir filesInUse && mv $fileName filesInUse && cd filesInUse && nano $fileName
    while [ -n "`pgrep nano`"  ]; do :; done
    mv $fileName .. && cd .. && rmdir filesInUse

    #Figure out a better way to name these backups to distinguish them more
    if [ -d backups ]; then
        cp $fileName backups/"${fileName}-backup"
    else
        mkdir backups && cp $fileName backups/"${fileName}-backup"
    fi

    #Theres aslo probably a better way of formatting these logs, figure this out
    if [ -d log ]; then
        echo "---EDIT---" >> log/"${fileName}-${username}-edit-log"
        diff -c $fileName olderVersion/$fileName >> log/"${fileName}-${username}-edit-log"
    else
        echo "---EDIT---" >> log/"${fileName}-${username}-edit-log"
        mkdir log && diff -c $fileName olderVersion/$fileName >> log/"${fileName}-${username}-edit-log"
    fi

    echo "Please add a comment for your entry (leave blank if not): "
    read comment
    echo "---${username}'s edit comment---">>log/"${fileName}-${username}-edit-log" && echo $comment >> log/"${fileName}-${username}-edit-log"

else
    echo "File does not exist, would you like to create it? (y/n): "

    #Implement the creation of new files inside the edit function?
fi


