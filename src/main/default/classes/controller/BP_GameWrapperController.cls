/**
 * Created by Jedrzej Gruca on 15/10/2023.
 */

public with sharing class BP_GameWrapperController {
    @AuraEnabled
    public static List<BP_GameWrapper> getGamesBySearchString(String gameName) {
        try {
            final BP_GameService service = BP_GameService.newInstance();
            if (gameName != null && gameName != '') {
                String modifiedGameName = gameName;
                if (gameName.contains(' ')) {
                    modifiedGameName = gameName.replace(' ', '_');
                }
                final HttpRequest request = service.prepareRequestToBgg(true, modifiedGameName, null);
                final HttpResponse response = service.executeCallout(request);
                final List<BP_GameWrapper> games = new List<BP_GameWrapper>();
                if (response.getStatusCode() == 200) {
                    games.addAll(service.parseSearchResponse(response));
                }
                return games;
            }
            else {
                return null;
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<BP_GameWrapper> getGamesById(Integer gameId) {
        try {
            final BP_GameService service = BP_GameService.newInstance();
            if (gameId != null) {
                final HttpRequest request = service.prepareRequestToBgg(false, null, gameId);
                final HttpResponse response = service.executeCallout(request);
                final List<BP_GameWrapper> games = new List<BP_GameWrapper>();
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