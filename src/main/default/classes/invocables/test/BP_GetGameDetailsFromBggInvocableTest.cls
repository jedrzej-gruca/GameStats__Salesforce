/**
 * Created by Jedrzej Gruca on 08/02/2024.
 */

@IsTest
public with sharing class BP_GetGameDetailsFromBggInvocableTest {

    public static final String FAKE_SEARCH_ENDPOINT = 'https://api.geekdo.com/xmlapi/search?search=Ark_Nova';
    public static final String FAKE_GAME_ENDPOINT = 'https://api.geekdo.com/xmlapi/boardgame/342942';

    private static final String SERVICE_METHOD_NOT_CALLED_MESSAGE = 'Service method was not called!';
    private static final String MOCK_VERIFICATION_FAILED_MESSAGE = 'Mock verification failed!';

    @IsTest
    private static void getGameByIdTest() {
        BP_GetGameDetailsFromBggInvocable.FlowInput input = new BP_GetGameDetailsFromBggInvocable.FlowInput();
        input.BggId = 342942;

        HttpRequest fakeRequest = new HttpRequest();
        fakeRequest.setEndpoint(FAKE_GAME_ENDPOINT);
        fakeRequest.setMethod('GET');

        HttpResponse fakeResponse = new HttpResponse();
        fakeResponse.setStatus('OK');
        fakeResponse.setStatusCode(200);

        BP_GameWrapper fakeWrapper = new BP_GameWrapper();
        fakeWrapper.bggId = 342942;
        fakeWrapper.name = 'Ark Nova';

        final fflib_ApexMocks mocks = new fflib_ApexMocks();
        final BP_GameService gameServiceMock = (BP_GameService) mocks.mock(BP_GameService.class);
        mocks.startStubbing();
        mocks.when(gameServiceMock.prepareRequestToBgg(false, null, fakeWrapper.bggId))
                .thenReturn(fakeRequest);
        mocks.when(gameServiceMock.executeCallout(fakeRequest)).thenReturn(fakeResponse);
        mocks.when(gameServiceMock.parseResponseDomToGame(fakeResponse)).thenReturn(new List<BP_GameWrapper>{fakeWrapper});
        mocks.stopStubbing();
        BP_Application.service.setMock(BP_GameService.BP_IGameService.class, gameServiceMock);

        BP_GetGameDetailsFromBggInvocable.getGameById(new List<BP_GetGameDetailsFromBggInvocable.FlowInput>{input});

        fflib_ApexMocks.ApexMocksException mockException;
        try {
            ((BP_GameService)mocks.verify(gameServiceMock, mocks.times(1).description(SERVICE_METHOD_NOT_CALLED_MESSAGE))).prepareRequestToBgg(false, null, fakeWrapper.bggId);
            ((BP_GameService)mocks.verify(gameServiceMock, mocks.times(1).description(SERVICE_METHOD_NOT_CALLED_MESSAGE))).executeCallout(fakeRequest);
            ((BP_GameService)mocks.verify(gameServiceMock, mocks.times(1).description(SERVICE_METHOD_NOT_CALLED_MESSAGE))).parseResponseDomToGame(fakeResponse);
        }
        catch (fflib_ApexMocks.ApexMocksException ex) {
            mockException = ex;
        }
        System.assertEquals(null, mockException, MOCK_VERIFICATION_FAILED_MESSAGE);
    }
}