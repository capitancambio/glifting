function SimpleGraphsRunEssex(inputPath,outputPath)
        %  
        % inputs: inputPath,outputPath
        % outputs: 

        %set the debugger
        Logger.clear(Logger.DEBUG);
        %essex subjects 
        users=101:112;

        %create the experiment factory 
        factory=SimpleGraphJobsEssex(inputPath,outputPath);
        %create the jobs for the users
        jobManager=factory.forUsers(users);
        %and run them, if matlab pool executor is available 
        %instead of run parallelRun can be invoked
        jobManager.run();


        %create the experiment factory 
        factory=SimpleGraphJobsEssexNFold(inputPath,outputPath);
        %create the jobs for the users
        jobManager=factory.forUsers(users);
        %and run them, if matlab pool executor is available 
        %instead of run parallelRun can be invoked
        jobManager.run();
end
