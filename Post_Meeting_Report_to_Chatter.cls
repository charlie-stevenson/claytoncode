public class Post_Meeting_Report_to_Chatter {
    @InvocableMethod(label='Assign to next AdOps' description='Assigns this opportunity to the next Custom User (Ad Ops)')

    public static void Post_Me (list<string> this_event_id) {

        event this_event = [select id,
                            Who_would_you_like_to_inform__c,
                            subject,
                            ActivityDate,
                            Description,
                            meeting_summary__c,
                            follow_up_actions__c,
                            meeting_type__c,
                            what.name
                            from event where id = :this_event_id[0]];

        string inform_pl = this_event.Who_would_you_like_to_inform__c + ';';
        List<String> peoples_names_list = inform_pl.split(';');

/*Convert to SET, and Add Defaults - NB Sets won't duplicate if he is already there*/
                Set<String> peoples_names = new Set<String>();
                for (string this_name : peoples_names_list) {
                    peoples_names.add(this_name);
                }
                
                list<meeting_report_default__mdt> defaults = [select MasterLabel from meeting_report_default__mdt];
                for (meeting_report_default__mdt this_default : defaults) {
                    peoples_names.add(this_default.MasterLabel);
                    }

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

        if (this_event.what.name!='') {
        relatedtotext = this_event.what.name + '\n';
            }

/*find the 'who' people from the event*/
        map<id, EventRelation> whoRelations = new map<id, EventRelation>([SELECT Id, Relation.Name
                                                                        FROM EventRelation
                                                                        WHERE EventId = :this_event.id AND isParent = true AND isWhat = false]);

        list<string>  attendee_names = new list<string>();
        for (eventRelation this_attendee : whoRelations.values()) { attendee_names.add(this_attendee.relation.Name); }

/*Don't post unless someone needs to be @mentioned*/
        if (anyoneFound) {

            String communityId = null;
            id feedElementId = this_event.id;

/* build the post from the event fields*/
            string post = 'Meeting Report : ' + this_event.meeting_type__c +
                    '\n- - - - - - - - - - - \n\nSubject \n- - - - - - - - - - - \n'+
                    this_event.Subject +
                    '\n\nDate : ' +
                    string.valueof(this_event.ActivityDate.day()) + '/' + string.valueof(this_event.ActivityDate.month()) + '/' + string.valueof(this_event.ActivityDate.year()) +
                    '\n\nWho \n- - - - - - - - - - - \n';

            for (string attendee : attendee_names) {post = post + attendee +'\n';}
            post = post + relatedtotext;

            post = post +
                    '\nDescription \n- - - - - - - - - - - \n' +
                    this_event.Description +
                    '\n\nSummary \n- - - - - - - - - - - \n' +
                    this_event.Meeting_Summary__c +
                    '\n\nFollow up actions\n- - - - - - - - - - -\n' +
                    this_event.Follow_up_actions__c +
                    '\n\n';

/*Build a Chatter Message*/
      ConnectApi.FeedItemInput feedItemInput             = new ConnectApi.FeedItemInput();
            ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
            ConnectApi.MessageBodyInput messageBodyInput       = new ConnectApi.MessageBodyInput();
            ConnectApi.TextSegmentInput textSegmentInput       = new ConnectApi.TextSegmentInput();

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
            feedItemInput.subjectId = this_event.Id;
/* post it*/
            ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemInput, null);

        }
    }
}