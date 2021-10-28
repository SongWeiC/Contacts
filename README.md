# Contacts

Hi There,

This project is build using xCode 13.1
and using cocoapods as dependency for 3 external libaries
1. Kingfisher, the image loader
2. Snapkit, the layout helper
3. Promisekit, the control helper


##############################################
here are some high level of the structure and layer of the app.

1. Contacts application uses coordinator design pattern
    - so navigate from home page, to details page, edit/add contact page, is managed by UICoordinator class.

2. ContactDataSource class is the ViewModel class basically that handle the UI data that going to show for each page. ContactDataSource class is created in appRegistry class and injected into each ViewController through initialiser injection method.

3. ContactDataSource is the adapter class that interface with DataProviderService. 

4. DataProviderService is the class that decide where should the data come from (either from local or API).

5. NetworkServiceRequest is where the actual API call from.

6. CoreDataService is the class that interact with storage.


So basically in ViewModel point of view, from top down

					ContactDataSource 
						|
					 DataProviderService
						|
				CoreDataService AND NetworkService
        
Thank you for reading =)
Song Wei
