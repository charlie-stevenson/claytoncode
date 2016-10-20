public class Post_Call_Email_to_Chatter {
    @InvocableMethod(label='Post Task to Chatter' description='Post a call email report to chatter')

    public static void Post_Me (list<string> this_task_id) {
        
        task this_task = [select id,
                            Who_would_you_like_to_inform__c, 
                            subject, 
                            ActivityDate,
                            createddate,
                            what.name,
                            description,
                            type
                            from task where id = :this_task_id[0]];

/* handle empty activity date*/
        if(this_task.ActivityDate==null) {
        	this_task.ActivityDate = this_task.createddate.date();
        }

/* parse the muliselect picklist  */
        string inform_pl = this_task.Who_would_you_like_to_inform__c;
        String[] peoples_names = inform_pl.split(';');

/*build a map of user names, and ids*/        
        map<id,user> active_users_idmap = new map<id,user>([select id, name from user where isactive = true]);
        map<string,id> active_users_namemap = new map<string,id>();
        
        for (user this_user : active_users_idmap.values()) { active_users_namemap.put(this_user.name, this_user.id); }
        
/*loop through the picklist field and lookup the user id*/
        list<id> parsed_results = new list<id>();
        boolean anyoneFound = false;
                
        for (string this_person : peoples_names) {
            if (active_users_namemap.containskey(this_person)) {
                parsed_results.add(active_users_namemap.get(this_person));
                anyoneFound = true;
            }
        }
/*is there a account or opportunity in the whatid*/
        string relatedtotext = '';

        if (this_task.what.name!=null) {
        relatedtotext = this_task.what.name + '\n';
            }
        
/*find the 'who' people from the task*/
        map<id, taskRelation> whoRelations = new map<id, taskRelation>([SELECT Id, Relation.Name
                                                                        FROM taskRelation
                                                                        WHERE taskId = :this_task.id AND isWhat = false]);
                
        list<string>  attendee_names = new list<string>();
        for (taskRelation this_attendee : whoRelations.values()) { attendee_names.add(this_attendee.relation.Name); }

/*Don't post unless someone needs to be @mentioned*/
        if (anyoneFound) {
            
            String communityId = null;
            id feedElementId = this_task.id;
            
/* build the post from the task fields*/
            string post = this_task.type + ' Report' +
                    '\n- - - - - - - - - - - \n\nSubject \n- - - - - - - - - - - \n'+
                    this_task.Subject +
                    '\n\nDate : ' +
                    string.valueof(this_task.ActivityDate.day()) + '/' + string.valueof(this_task.ActivityDate.month()) + '/' + string.valueof(this_task.ActivityDate.year()) +
                    '\n\nWho \n- - - - - - - - - - - \n';

            for (string attendee : attendee_names) {post = post + attendee +'\n';}
            post = post + relatedtotext;
            
            string description = '';

            if(this_task.description!=null)
               {description = '\nDescription \n- - - - - - - - - - - \n' + this_task.description + '\n';}

            post = post + description;

/*Build a Chatter Message*/
            ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
            ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
            ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
            ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
            
            textSegmentInput.text = post;

            messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();

            messageBodyInput.messageSegments.add(textSegmentInput);

/* add the @mentions using user.id*/            
            for (id this_mention : parsed_results) {
                mentionSegmentInput = new ConnectApi.MentionSegmentInput();
                mentionSegmentInput.id = this_mention;
                messageBodyInput.messageSegments.add(mentionSegmentInput);
                system.debug(this_mention);
                }

            feedItemInput.body = messageBodyInput;
            feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
            feedItemInput.subjectId = this_task.Id;
/* post it*/
            ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemInput, null);
            
        }
    }
}