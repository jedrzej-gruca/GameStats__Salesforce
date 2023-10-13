/**
 * Created by Jedrzej Gruca on 12/10/2023.
 */

public with sharing class BP_GameService implements BP_IGameService {

    public String prepareSearchEndpoint(final String gameName) {
        return BP_Constants.BGG_ENDPOINT + BP_Constants.SEARCH_HTTP_REQUEST_TYPE + gameName;
    }

    public String prepareSingleGameRecordEndpoint(final Integer bggGameId) {
        return BP_Constants.BGG_ENDPOINT + BP_Constants.GAME_HTTP_REQUEST_TYPE + bggGameId;
    }

    public HttpRequest prepareRequestToBgg(final Boolean isSearch, final String gameName, final Integer bggGameId) {
        HttpRequest request = new HttpRequest();
        String endpoint;
        if (isSearch && gameName != null) {
            endpoint = prepareSearchEndpoint(gameName);
        } else if (bggGameId != null) {
            endpoint = prepareSingleGameRecordEndpoint(bggGameId);
        }
        if (endpoint == null) {
            return null;
        }
        request.setEndpoint(endpoint);
        request.setMethod('GET');
        return request;
    }

    public HttpResponse executeCallout(final HttpRequest request) {
        Http http = new Http();
        final HttpResponse response = http.send(request);
        return response;
    }

    public List<BP_Game__c> parseResponseDomToGame(final HttpResponse response, final Boolean isSearch) {
        Dom.Document doc = response.getBodyDocument();

        //Retrieve the root element for this document.
        Dom.XMLNode games = doc.getRootElement();
        final List<BP_Game__c> boardGames = new List<BP_Game__c>();
        for(Dom.XMLNode child : games.getChildElements()) {
            System.debug(child.getText());
        }
//        String name = games.getChildElement('name', null).getText();
//        String state = games.getChildElement('state', null).getText();
        // print out specific elements
//        System.debug('Name: ' + name);
//        System.debug('State: ' + state);

        // Alternatively, loop through the child elements.
        // This prints out all the elements of the address

        return null;
    }

    public interface BP_IGameService {
        HttpRequest prepareRequestToBgg(Boolean isSearch, String gameName, Integer bggGameId);
        String prepareSearchEndpoint(String gameName);
        String prepareSingleGameRecordEndpoint(Integer bggGameId);
        HttpResponse executeCallout(HttpRequest request);
    }
}