editFile()
{
    userName=$(whoami)
    clear
    echo "File editing"

    echo "Avaliable files: "
    ls -p | grep -v /

    echo " "
    echo "Enter name of file you wish to edit: "
    read filename

    if [ -f "$filename" ]; then

        mkdir $userName && mv $filename $userName && cd $userName && nano $filename

        while [ -n "`pgrep nano`" ]; do :; done

        mv $filename .. && cd .. && rmdir $userName
        cd Backups || (mkdir Backups && cd Backups)

        if [ -f "$filename"* ]; then

            fileComparison=$(ls -t $filename* | head -1)
            Changes=$(diff $fileComparison ../$filename) 
            cd ..
            cd logs || mkdir logs && cd logs
            log=$(ls -t $filename* | head -1)
            echo "Edited by user: $(whoami) on $(date)">>$log
            echo "Updates:">>$log
            echo $Changes>>$log
            echo "">>$log
            cd ..
        else
            cd ..
            cd logs || mkdir logs && cd logs
            changeLog="$(echo $filename)_logs"
            touch $changeLog
            echo $(whoami)>$changeLog
            echo "Created by user: $(whoami) on $(date)">>$changeLog
            echo "Additions:">>$changeLog
            cat ../$filename>>$changeLog
            echo "">>$changeLog
            cd ..
        fi

        echo "Completed"

    else
        echo "Error - does not exist. Try again."
    fi
}