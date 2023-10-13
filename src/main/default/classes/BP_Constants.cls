/**
 * Created by Jedrzej Gruca on 12/10/2023.
 */

public with sharing class BP_Constants {
    /**
     * @description BGG API Http request types
     */
    public static final String SEARCH_HTTP_REQUEST_TYPE = 'search?search=';
    public static final String GAME_HTTP_REQUEST_TYPE = 'game/';

    /**
     * @description BGG API endpoint
     */
    public static final String BGG_ENDPOINT = 'https://boardgamegeek.com/xmlapi/';

    /**
     * @description BGG API XML node names
     */
    public static final String ROOT_NODE_NAME = 'boardgames';
    public static final String BOARDGAME_NODE_NAME = 'boardgame';
    public static final String BOARDGAME_NODE_ATTRIBUTE_NAME = 'objectid';


    public static final String YEAR_PUBLISHED_SUBNODE_NAME = 'yearpublished';
    public static final String MIN_PLAYERS_SUBNODE_NAME = 'minplayers';
    public static final String MAX_PLAYERS_SUBNODE_NAME = 'maxplayers';
    public static final String MIN_PLAYTIME_SUBNODE_NAME = 'minplaytime';
    public static final String MAX_PLAYTIME_SUBNODE_NAME = 'maxplaytime';
    public static final String AGE_SUBNODE_NAME = 'age';
    public static final String NAME_SUBNODE_NAME = 'name';
    public static final String NAME_SUBNODE_ATTRIBUTE_NAME = 'primary';

    public static final String DESCRIPTION_SUBNODE_NAME = 'description';
    public static final String BOARDGAME_MECHANIC_SUBNODE_NAME = 'boardgamemechanic';
    public static final String BOARDGAME_CATEGORY_SUBNODE_NAME = 'boardgamecategory';
    public static final String BOARDGAME_DESIGNER_SUBNODE_NAME = 'boardgamedesigner';
    public static final String BOARDGAME_SUBDOMAIN_SUBNODE_NAME = 'boardgamesubdomain';
}