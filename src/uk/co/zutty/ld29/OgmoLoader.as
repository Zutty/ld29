package uk.co.zutty.ld29 {
    import flash.utils.ByteArray;

    import net.flashpunk.Entity;
    import net.flashpunk.graphics.Tilemap;
    import net.flashpunk.masks.Grid;

    public class OgmoLoader {

        [Embed(source="/level.oel", mimeType="application/octet-stream")]
        private static const OGMO_LEVEL_FILE:Class;
        [Embed(source="/tiles.png")]
        private static const TILES_IMAGE:Class;

        private static const TERRAIN_LAYER_NAME:String = "ground";
        private static const TILE_SIZE:int = 24;

        private var _xmlData:XML;

        public function OgmoLoader() {
            var bytes:ByteArray = new OGMO_LEVEL_FILE();
            _xmlData = new XML(bytes.readUTFBytes(bytes.length));
        }

        public function get terrain():Entity {
            var terrain:Entity = new Entity();

            var tilemap:Tilemap = new Tilemap(TILES_IMAGE, _xmlData.width, _xmlData.height, TILE_SIZE, TILE_SIZE);
            var grid:Grid = new Grid(_xmlData.width, _xmlData.height, TILE_SIZE, TILE_SIZE);

            for each(var tile:XML in _xmlData[TERRAIN_LAYER_NAME][0].tile) {
                var idx:uint = tilemap.getIndex(tile.@tx / TILE_SIZE, tile.@ty / TILE_SIZE);
                tilemap.setTile(tile.@x / TILE_SIZE, tile.@y / TILE_SIZE, idx);
                grid.setTile(tile.@x / TILE_SIZE, tile.@y / TILE_SIZE);
            }

            terrain.addGraphic(tilemap);
            terrain.mask = grid;
            terrain.type = "terrain";
            terrain.layer = 600;

            return terrain;
        }
    }
}