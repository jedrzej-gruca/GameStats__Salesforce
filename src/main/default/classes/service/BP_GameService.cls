/**
 * Created by Jedrzej Gruca on 12/10/2023.
 */

public with sharing class BP_GameService implements BP_IGameService {

    public class GameWrapper {
        String name;
        Integer bggId;
        Integer yearPublished;
        Integer minPlayers;
        Integer maxPlayers;
        Integer minPlaytime;
        Integer maxPlaytime;
        Integer age;
        String description;
        String boardgameMechanic;
        String boardgameCategory;
        String boardgameDesigner;
        String boardgameSubdomain;
    }

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

    public Map<String, String> parseSearchResponse(final HttpResponse response) {
        final Dom.Document gameList = response.getBodyDocument();
        final Map<String, String> gameIdToGameNameMap = new Map<String, String>();
        Dom.XmlNode games = gameList.getRootElement();
        for (Dom.XmlNode game : games.getChildElements()) {
            final String gameId = game.getAttribute(BP_Constants.BOARDGAME_NODE_ATTRIBUTE_NAME, null);
            final String gameName = game.getChildElement(BP_Constants.NAME_SUBNODE_NAME, null).getText();
            gameIdToGameNameMap.put(gameId, gameName);
        }
        if (gameIdToGameNameMap.isEmpty()) {
            return null;
        }
        return gameIdToGameNameMap;
    }

    public List<GameWrapper> parseResponseDomToGame(final HttpResponse response) {
        final Dom.Document gameList = response.getBodyDocument();

        //Retrieve the root element for this document.
        final Dom.XmlNode games = gameList.getRootElement();
        final List<GameWrapper> boardGames = new List<GameWrapper>();
        for(Dom.XmlNode game : games.getChildElements()) {
            final GameWrapper gameWrapper = new GameWrapper();
            gameWrapper.bggId = Integer.valueOf(game.getAttribute(BP_Constants.BOARDGAME_NODE_ATTRIBUTE_NAME, null));
            for (Dom.XmlNode name : game.getChildElements()) {
                if (name.getName().contains(BP_Constants.NAME_SUBNODE_NAME)) {
                    if (name.getAttribute(BP_Constants.NAME_SUBNODE_ATTRIBUTE_NAME, null) == 'true') {
                        System.debug(name.getText());
                        gameWrapper.name = name.getText();
                        break;
                    }
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
            gameWrapper.boardgameSubdomain = game.getChildElement(BP_Constants.BOARDGAME_SUBDOMAIN_SUBNODE_NAME, null).getText();
            gameWrapper.boardgameCategory = game.getChildElement(BP_Constants.BOARDGAME_CATEGORY_SUBNODE_NAME, null).getText();
            gameWrapper.boardgameMechanic = game.getChildElement(BP_Constants.BOARDGAME_MECHANIC_SUBNODE_NAME, null).getText();
            boardGames.add(gameWrapper);
        }
        return boardGames;
    }

    public interface BP_IGameService {
        HttpRequest prepareRequestToBgg(Boolean isSearch, String gameName, Integer bggGameId);
        String prepareSearchEndpoint(String gameName);
        String prepareSingleGameRecordEndpoint(Integer bggGameId);
        HttpResponse executeCallout(HttpRequest request);
        Map<String, String> parseSearchResponse(HttpResponse response);
        List<GameWrapper> parseResponseDomToGame(HttpResponse response);
    }
}