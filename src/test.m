Logger.clear(Logger.DEBUG);

factory=JobFactory('/home/javi/bci/mydata/','/home/javi/tmp/data.csv');
jobManager=factory.forUsers(101:113);
jobManager.run()

