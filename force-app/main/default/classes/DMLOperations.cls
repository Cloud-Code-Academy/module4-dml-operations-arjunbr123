/**
 * The DMLOperations class serves as a deep dive into Data Manipulation Language (DML) in Apex.
 * It covers fundamental DML operations such as insert, update, upsert, and delete.
 *
 * This class introduces developers to the concept of manipulating Salesforce records in Apex.
 * It discusses how to use DML operations to create, update, and delete records.
 * This class uses standard Salesforce objects like Account, Contact, and Opportunity for demonstration.
 *
 * Topics covered in this class include:
 * - Understanding how to use insert DML operation to create records in Salesforce.
 * - Understanding how to use update and upsert DML operations to update existing records in Salesforce.
 * - Understanding how to use delete DML operation to remove records from Salesforce.
 *
 * Users of this class can expect to gain a strong understanding of DML operations in Apex and
 * be prepared for more advanced topics in Salesforce development.
 *
 * The methods within this class serve as practical examples of different DML operations,
 * allowing developers to learn through practice and examples.
 *
 * @author Arjun2.0
 */


public with sharing class DMLOperations {

    /**
     * Question 1
     * Create a new Account object and inserts it into the database.
     * The Account will have a random name for uniqueness.
     * @return The Id of the newly created Account.
     */
    public static Id insertNewAccount() {
        Account myAccount = new Account();
        myAccount.Name = 'Arjuns Groups';
        myAccount.BillingCity = 'Bothell';
        Insert myAccount;
        return myAccount.Id;
    }

    /**
     * Question 2
     * Create a new Account with the specified name and industry provided.
     * @param name The name of the account to be created.
     * @param industry The industry of the account to be created.
     */
    public static void createAccount(String name, String industry) {
        Account myAccount1 = new Account();
        myAccount1.Name = name;
        myAccount1.Industry = industry;
        Insert myAccount1;
    }

    
    /**
     * Question 3
     * Create a new Contact and link it to the Account id provided then inserts it into the database.
     * @param accountId The Id of the Account to link the Contact to.
     * @return The Id of the newly created Contact.
     */
    public static Id insertNewContact(Id accountId) {
        // Create a new Contact instance

        Contact myContact = new Contact();
        myContact.FirstName = 'Arjun';
        myContact.LastName = 'Reddy';
        myContact.AccountId = accountId;
        Insert myContact;
        return myContact.Id;
    }

    /**
     * Question 4
     * Update the last name of a Contact in the database.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param contactId The Id of the Contact to update.
     * @param newLastName The new last name for the Contact.
     */
    public static void updateContactLastName(Id contactId, String newLastName) {
        Contact myContact = [SELECT ID FROM Contact where Id = :contactId];
            myContact.LastName = newLastName;
            update myContact;
    }

    /**
     * Question 5
     * Update the stage of an Opportunity in the database.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param oppId The Id of the Opportunity to update.
     * @param newStage The new stage for the Opportunity.
     */
    public static void updateOpportunityStage(Id oppId, String newStage) {
        Opportunity myOpty = [SELECT Id FROM Opportunity WHERE Id = :oppId];
        if(myOpty.Id != null){
           myOpty.StageName = newStage;
           Update myOpty;
    }
}

    /**
     * Question 6
     * Update the Account's Name and Industry given an Account Id.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param accountId The Id of the account to be updated.
     * @param newName The new name for the account.
     * @param newIndustry The new industry for the account.
     */
    public static void updateAccountFields(Id accountId, String newName, String newIndustry) {
        Account myAcc = [SELECT Id FROM Account WHERE Id = :accountId];
        if(myAcc.Id != null){
            myAcc.Name = newName;
            myAcc.Industry = newIndustry;
            update myAcc;
        }
    }


    /**
     * Question 7
     * Create or updates an Opportunities
     * The Opportunity's Stage is set to Qualification.
     * The Opportunity's Close Date is set to 3 months from today.
     * The Opportunity's Amount is set to 50000.
     * @param list of Opportunities to be changed then upserted.
     */
    public static void upsertOpportunityList(List<Opportunity> opportunities) {
        for (Opportunity myOpp : opportunities) {
            myOpp.StageName = 'Qualification';
            myOpp.CloseDate = Date.today().addMonths(3);
            myOpp.Amount = 50000;
            Upsert myOpp;
         }
    }

    /**
     * Question 8
     * Insert or updates opportunities from list of names.
     * Associate the Opportunities with account that has the name accountName.
     * There should be an Opportunity for each name provided in the list.
     * @param accountName The name of the Account.
     * @param oppNames The list of Opportunity names.
     */
    public static void upsertOpportunities(String accountName, List<String> oppNames) {
        //Opportunity opp = new Opportunity();
  
        //Account testAcc1 = new Account(Name = accountName);
        //upsert testAcc1;

       List<Account> acc = [SELECT Id FROM Account WHERE Name = :accountName LIMIT 1];     
       Id myId;
       if(acc.size()>0){
       myId = acc.get(0).Id;
       }
       else{
        Account testAcc1 = new Account(Name = accountName);
        Insert testAcc1;
       myId = testAcc1.Id;
       }
       List <Opportunity> myList = new List<Opportunity>();   
        for (Integer i=0; i<oppNames.size(); i++) {    
            Opportunity opp = new Opportunity(AccountId=myId,Name=oppNames[i],StageName='Prospecting',CloseDate = Date.today());       
                myList.add(opp);             
            }
            System.debug(myList);
            Upsert myList Name;
       
    }
    
    /**
     * Question 9
	 * Upserts an Account with the specified name.
	 * If an Account with the given name already exists, update the description to "Updated Account".
	 * If no such Account exists, it creates a new one and sets the description to "New Account".
	 * @param accountName The name of the Account to be upserted.
	 * @return The Account that was upserted.
	 */
	public static Account upsertAccount(String accountName) {
		Account[] account = [SELECT Id FROM Account WHERE Name = :accountName LIMIT 1];
        Account finalAcc = new Account();

        if (account.size()>0) {
            for (Account acc : account) {
                if(acc.Id!= null){
                    finalAcc.Name = accountName;
                    finalAcc.Description = 'Updated Account';
                }
            } 
        }
        else{
            finalAcc.Name = accountName;
            finalAcc.Description = 'New Account';
        }
        Upsert finalAcc;      
        return finalAcc;

        }


    /**
     * Question 10
	 * Upserts accounts and links contacts to them based on the contact's last name and account name.
	 * Create or use existing account with contact last name. (Hint: use previous upsertAccount method - this may cause bad practices but for learning purposes it's okay.)
	 * Contacts are then linked to these accounts based on a full last name match.
     * Example Contact Last Name = Doe Link to Account Name = Doe 
     * Example Contact Last Name = Jane Link to Account Name = Jane
	 * @param contactsToUpsert List of Contacts to be upserted and linked to accounts.
	 */
	public static void upsertAccountsWithContacts(List<Contact> contactsToUpsert) {
        Contact myCon = new Contact();
        Account myAcc = new Account();

        for (Contact con : contactsToUpsert) {
            myAcc = upsertAccount(con.LastName);
            myCon = new Contact(LastName = myAcc.Name);
            myCon.AccountId = myAcc.Id;
            upsert myCon;  
        }
	}
	
          
		// Extract the Account Name from Contact's LastName

		// Get the account based on the name or create one if it doesn't exist

		// Link the Contact to its Account using the Account Id

		// Upsert the Contacts


    /**
     * Question 11
     * Insert a list of Leads and then deletes them.
     * @param leadNames The list of Lead names to be inserted.
     */
    public static void insertAndDeleteLeads(List<String> leadNames) {
        // Loop through each Lead name
        Lead myLead = new Lead();
        for (String leadName : leadNames) {
            myLead.LastName = leadName;
            myLead.Company = leadName;
  
        }
        Upsert myLead;
        Delete myLead;
    }


    /**
     * Question 12
     * Dynamically create the number of cases and relate it to the accountId, then deletes them.
     * @param accountId The account for which the cases will be created and then deleted.
     * @param numOfCases The number of cases to create.
     */
    public static void createAndDeleteCases(String accountId, Integer numOfCases) {
        // Insert the cases
        List<Case> newCases = new List<Case>();
        Case myCase = new Case();
        for (Integer i=0; i<numOfCases; i++) {
            Case newCase = new Case (AccountId = accountId);
            newCases.add(newCase);
        }
       
        Insert newCases;
        Delete newCases;
    }
}