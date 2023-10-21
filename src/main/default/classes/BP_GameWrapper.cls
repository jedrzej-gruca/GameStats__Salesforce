/**
 * Created by Jedrzej Gruca on 20/10/2023.
 */

public class BP_GameWrapper {

    @AuraEnabled @InvocableVariable
    public String name ;
    @AuraEnabled @InvocableVariable
    public Integer bggId ;
    @InvocableVariable
    public Integer yearPublished;
    @InvocableVariable
    public Integer minPlayers;
    @InvocableVariable
    public Integer maxPlayers;
    @InvocableVariable
    public Integer minPlaytime;
    @InvocableVariable
    public Integer maxPlaytime;
    @InvocableVariable
    public Integer age;
    @InvocableVariable
    public String description;
    @InvocableVariable
    public String boardgameDesigner;
    @InvocableVariable
    public List<String> boardgameMechanic;
    @InvocableVariable
    public List<String> boardgameCategory;
    @InvocableVariable
    public List<String> boardgameSubdomain;
}