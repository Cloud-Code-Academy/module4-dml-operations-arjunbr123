// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

string tempvar = 'Enter_your_name_here';
System.debug('Hello World!');
System.debug('My name is ' + tempvar);


		Account testAccount = new Account(Name = 'Doe');
		insert testAccount;
		// Create test contacts with last names matching account names
		List<Contact> testContacts = new List<Contact>{
			new Contact(LastName = 'Doe', FirstName = 'John'),
			new Contact(LastName = 'Smith', FirstName = 'Jane')
		};
        DMLOperations.upsertAccountsWithContacts(testContacts);


SELECT Name FROM Account where Id = '001Dn000014w4qoIAA'

[{"Id":"001Dn000014w4qmIAA"},{"Id":"001Dn000014w4qnIAA"},{"Id":"001Dn000014w4qoIAA"}]



        //select Id from Account where Name = 'Smith'