/**
 * Created by drzeju on 15/10/2023.
 */

public with sharing class BP_GameWrapperController {
    @AuraEnabled
    public static Map<Integer, String> getGamesBySearchString(String gameName) {
        try {
            final BP_GameService service = BP_GameService.newInstance();
            if (gameName != null && gameName != '') {
                final HttpRequest request = service.prepareRequestToBgg(true, gameName, null);
                final HttpResponse response = service.executeCallout(request);
                final Map<Integer, String> gameIdToNameMAp = new Map<Integer, String>();
                if (response.getStatusCode() == 200) {
                    gameIdToNameMAp.putAll(service.parseSearchResponse(response));
                }
                return gameIdToNameMAp;
            }
            else {
                return null;
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<BP_GameService.GameWrapper> getGamesById(Integer gameId) {
        try {
            final BP_GameService service = BP_GameService.newInstance();
            if (gameId != null) {
                final HttpRequest request = service.prepareRequestToBgg(false, null, gameId);
                final HttpResponse response = service.executeCallout(request);
                final List<BP_GameService.GameWrapper> games = new List<BP_GameService.GameWrapper>();
                if (response.getStatusCode() == 200) {
                    games.addAll(service.parseResponseDomToGame(response));
                }
                return games;
            } else {
                return null;
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}