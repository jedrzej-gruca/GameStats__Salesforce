/**
 * Created by Jedrzej Gruca on 20/10/2023.
 */

public with sharing class BP_GetGameDetailsFromBggInvocable {

    public class FlowInput {
        @InvocableVariable(Required=true)
        public Integer BggId;
    }

    @InvocableMethod(
            Label='Get game details using bgg api'
            Description='Returns details of chosen game'
            Callout=true
    )
//    public static BP_GameWrapper getGameById(List<FlowInput> inputs) {
    public static List<BP_GameWrapper> getGameById(List<FlowInput> inputs) {
        final FlowInput input = inputs[0];
        final Integer bggId = input.BggId;
        final BP_GameService service = BP_GameService.newInstance();
        if (bggId != null) {
            final HttpRequest request = service.prepareRequestToBgg(false, null, bggId);
            final HttpResponse response = service.executeCallout(request);
//            BP_GameWrapper game;
            final List<BP_GameWrapper> games = new List<BP_GameWrapper>();
            if (response.getStatusCode() == 200) {
//                game = service.parseResponseDomToGame(response).get(0);
                games.addAll(service.parseResponseDomToGame(response));
            }
//            return game;
            return games;
        } else {
            return null;
        }
    }
}