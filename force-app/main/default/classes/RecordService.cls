public with sharing class RecordService {
  @AuraEnabled
  public static List<Id> createRecords(Id recordId) {
    List<Id> createdUpdatedRecords = new List<Id>();

    // Update current record
    Account acc = new Account(
      Id = recordId,
      Name = ('Texeï - ' + DateTime.now()),
      Website = 'https://texei.com/blog'
    );
    update acc;
    createdUpdatedRecords.add(acc.Id);

    // Create Contact
    Contact c = new Contact(
      FirstName = 'Fabien',
      LastName = 'Taillon',
      AccountId = recordId
    );
    insert c;
    createdUpdatedRecords.add(c.Id);

    // Create Opportunity
    Opportunity opp = new Opportunity(
      Name = 'My opportunity',
      CloseDate = Date.today(),
      StageName = 'Qualification',
      AccountId = recordId
    );
    insert opp;
    createdUpdatedRecords.add(opp.Id);

    // Create Case
    Case ca = new Case(AccountId = recordId);
    insert ca;
    createdUpdatedRecords.add(ca.Id);

    // Create Account Contact Relation
    Account a = new Account(Name = 'Pied Piper');
    insert a;
    createdUpdatedRecords.add(a.Id);
    Contact c2 = new Contact(
      FirstName = 'Matthieu',
      LastName = 'Hasser',
      AccountId = a.Id
    );
    insert c2;
    createdUpdatedRecords.add(c2.Id);
    AccountContactRelation acr = new AccountContactRelation(
      AccountId = recordId,
      ContactId = c2.Id
    );
    insert acr;
    createdUpdatedRecords.add(acr.Id);

    // Create Account Team Member
    AccountTeamMember atm = new AccountTeamMember();
    atm.AccountId = recordId;
    atm.UserId = UserInfo.getUserId();
    atm.TeamMemberRole = 'Account Manager';
    insert atm;
    createdUpdatedRecords.add(atm.Id);

    // Create Partner
    AccountPartner ap = new AccountPartner();
    ap.AccountFromId = recordId;
    ap.AccountToId = a.Id;
    insert ap;
    createdUpdatedRecords.add(ap.Id);

    // Create Note
    Note n = new Note(
      Title = 'My Note',
      Body = 'My note body',
      ParentId = recordId
    );
    insert n;
    createdUpdatedRecords.add(n.Id);

    // Create Task
    Task t = new Task(Subject = 'My Task', WhatId = recordId);
    insert t;
    createdUpdatedRecords.add(t.Id);

    // Create Event
    Event e = new Event(
      Subject = 'My Event',
      WhatId = recordId,
      StartDateTime = DateTime.now(),
      EndDateTime = DateTime.now()
    );
    insert e;
    createdUpdatedRecords.add(e.Id);

    // Files
    ContentVersion cv = new ContentVersion();
    cv.ContentLocation = 'S';
    cv.VersionData = Blob.valueOf('My file content');
    cv.Title = 'My File';
    cv.PathOnClient = 'My File.txt';
    insert cv;
    createdUpdatedRecords.add(cv.Id);

    Id contentDocumentId = [
      SELECT ContentDocumentId
      FROM ContentVersion
      WHERE Id = :cv.Id
      LIMIT 1
    ]
    .ContentDocumentId;

    ContentDocumentLink cdl = new ContentDocumentLink();
    cdl.ContentDocumentId = contentDocumentId;
    cdl.LinkedEntityId = recordId;
    cdl.ShareType = 'I';
    insert cdl;
    createdUpdatedRecords.add(cdl.Id);

    // Create Attachment
    Attachment attachment = new Attachment();
    attachment.Body = Blob.valueOf('My attachment body');
    attachment.Name = String.valueOf('My attachment.txt');
    attachment.ParentId = recordId;
    insert attachment;
    createdUpdatedRecords.add(attachment.Id);

    return createdUpdatedRecords;
  }

  @AuraEnabled(cacheable=true)
  public static String getRecordName(Id recordId) {
    return [SELECT Name FROM Account WHERE Id = :recordId LIMIT 1].Name;
  }
}
