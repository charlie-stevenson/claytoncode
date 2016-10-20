global class IDGRegHandler implements Auth.RegistrationHandler{

    public User createUser(Id portalId, Auth.UserData data){
        User u;
        try {        u = [SELECT Id FROM User WHERE username = :data.email
                                      OR    Email = :data.email+'.support'];
            }
        catch (Exception e) {
            System.debug(e);
        }
        return u;
    }

    public void updateUser(Id userId, Id portalId, Auth.UserData data){
        User u;        
        try{        u = [SELECT Id FROM User WHERE username = :data.email
                                      OR    Email = :data.email+'.support'];
           }
        catch (Exception e) {
            System.debug(e);
        }
    }
    
}