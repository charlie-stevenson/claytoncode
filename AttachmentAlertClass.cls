public class AttachmentAlertClass{

public static string PostThis(id mention_id, string mention_copyname, id opp_id, string message, string link){
String communityId = null;
ConnectApi.FeedType feedType = ConnectApi.FeedType.Record;
String userToMention1 = mention_id;
//Profile adminprofile  = [select id from profile where name='System Administrator' limit 1];
list<user> userToMention2 = [select id from user where name = :mention_copyname and isactive=true limit 1];
String subjectId = opp_id;

ConnectApi.MessageBodyInput messageInput = new ConnectApi.MessageBodyInput();
messageInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();

ConnectApi.TextSegmentInput textSegment = new ConnectApi.TextSegmentInput();
textSegment.text = message;
messageInput.messageSegments.add(textSegment);

ConnectApi.MentionSegmentInput mentionSegment = new ConnectApi.MentionSegmentInput();
mentionSegment.id = userToMention1;
messageInput.messageSegments.add(mentionSegment);

ConnectApi.MentionSegmentInput mentionSegment2 = new ConnectApi.MentionSegmentInput();
    if (userToMention2.size()==0)  {}
    else {
		mentionSegment2.id = userToMention2[0].id;
		messageInput.messageSegments.add(mentionSegment2);
    	}

system.debug('ukelele:'+SubjectId);

textSegment = new ConnectApi.TextSegmentInput();
textSegment.text = '.';
messageInput.messageSegments.add(textSegment);

ConnectApi.LinkSegmentInput linkSegment = new ConnectApi.LinkSegmentInput();
linkSegment.url = link;   
messageInput.messageSegments.add(linkSegment);
    
ConnectApi.FeedItemInput input = new ConnectApi.FeedItemInput();
input.body = messageInput;

ConnectApi.FeedItem feedItemRep = ConnectApi.ChatterFeeds.postFeedItem(communityId, feedType, subjectId, input, null);
return('ok');
}
}