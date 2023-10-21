/**
 * Created by Jedrzej Gruca on 12/10/2023.
 */

public with sharing class BP_GameService implements BP_IGameService {

    public static BP_GameService newInstance() {
        return (BP_GameService) BP_Application.service.newInstance(BP_IGameService.class);
    }

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

    public List<BP_GameWrapper> parseSearchResponse(final HttpResponse response) {
        final Dom.Document gameList = response.getBodyDocument();
        final List<BP_GameWrapper> retrievedGames = new List<BP_GameWrapper>();
        Dom.XmlNode games = gameList.getRootElement();
        for (Dom.XmlNode game : games.getChildElements()) {
            BP_GameWrapper gw = new BP_GameWrapper();
            gw.bggId = Integer.valueOf(game.getAttribute(BP_Constants.BOARDGAME_NODE_ATTRIBUTE_NAME, null));
            gw.name = game.getChildElement(BP_Constants.NAME_SUBNODE_NAME, null).getText();
            retrievedGames.add(gw);
        }
        if (retrievedGames.isEmpty()) {
            return null;
        }
        return retrievedGames;
    }

    public List<BP_GameWrapper> parseResponseDomToGame(final HttpResponse response) {
        final Dom.Document gameList = response.getBodyDocument();

        //Retrieve the root element for this document.
        final Dom.XmlNode games = gameList.getRootElement();
        final List<BP_GameWrapper> boardGames = new List<BP_GameWrapper>();
        for(Dom.XmlNode game : games.getChildElements()) {
            final BP_GameWrapper gameWrapper = new BP_GameWrapper();
            final List<String> subdomains = new List<String>();
            final List<String> categories = new List<String>();
            final List<String> mechanics = new List<String>();
            gameWrapper.bggId = Integer.valueOf(game.getAttribute(BP_Constants.BOARDGAME_NODE_ATTRIBUTE_NAME, null));
            for (Dom.XmlNode subNode : game.getChildElements()) {
                if (subNode.getName().contains(BP_Constants.NAME_SUBNODE_NAME)) {
                    if (subNode.getAttribute(BP_Constants.NAME_SUBNODE_ATTRIBUTE_NAME, null) == 'true') {
                        System.debug(subNode.getText());
                        gameWrapper.name = subNode.getText();
                    }
                } else if (subNode.getName().contains(BP_Constants.BOARDGAME_SUBDOMAIN_SUBNODE_NAME)) {
                    subdomains.add(subNode.getText());
                } else if (subNode.getName().contains(BP_Constants.BOARDGAME_CATEGORY_SUBNODE_NAME)) {
                    categories.add(subNode.getText());
                } else if (subNode.getName().contains(BP_Constants.BOARDGAME_MECHANIC_SUBNODE_NAME)) {
                    mechanics.add(subNode.getText());
                }
            }
            gameWrapper.yearPublished = Integer.valueOf(game.getChildElement(BP_Constants.YEAR_PUBLISHED_SUBNODE_NAME, null).getText());
            gameWrapper.minPlayers = Integer.valueOf(game.getChildElement(BP_Constants.MIN_PLAYERS_SUBNODE_NAME, null).getText());
            gameWrapper.maxPlayers = Integer.valueOf(game.getChildElement(BP_Constants.MAX_PLAYERS_SUBNODE_NAME, null).getText());
            gameWrapper.minPlaytime = Integer.valueOf(game.getChildElement(BP_Constants.MIN_PLAYTIME_SUBNODE_NAME, null).getText());
            gameWrapper.maxPlaytime = Integer.valueOf(game.getChildElement(BP_Constants.MAX_PLAYTIME_SUBNODE_NAME, null).getText());
            gameWrapper.age = Integer.valueOf(game.getChildElement(BP_Constants.AGE_SUBNODE_NAME, null).getText());
            gameWrapper.description = game.getChildElement(BP_Constants.DESCRIPTION_SUBNODE_NAME, null).getText();
            gameWrapper.boardgameDesigner = game.getChildElement(BP_Constants.BOARDGAME_DESIGNER_SUBNODE_NAME, null).getText();
            gameWrapper.boardgameSubdomain = subdomains;
            gameWrapper.boardgameCategory = categories;
            gameWrapper.boardgameMechanic = mechanics;
            boardGames.add(gameWrapper);
        }
        return boardGames;
    }

    public interface BP_IGameService {
        HttpRequest prepareRequestToBgg(Boolean isSearch, String gameName, Integer bggGameId);
        String prepareSearchEndpoint(String gameName);
        String prepareSingleGameRecordEndpoint(Integer bggGameId);
        HttpResponse executeCallout(HttpRequest request);
        List<BP_GameWrapper> parseSearchResponse(HttpResponse response);
        List<BP_GameWrapper> parseResponseDomToGame(HttpResponse response);
    }
}