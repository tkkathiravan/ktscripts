#get all the exceptions from the system to be used in try catch 
[appdomain]::CurrentDomain.GetAssemblies() | ForEach {
    Try {
        $_.GetExportedTypes() | Where {
            $_.Fullname -match 'Exception'
        }
    } Catch {}
} | Select FullName
