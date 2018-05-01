<template>
	<div class='box' style="border-right: none;">
        <div id='search-options' class='bordered'>
          <div id='search-options-left'>
            <div id='options-label label' style="color: #efefef">MAP CONTROLS</div>
            <div id='options-background' tooltip='Change the background map'>
              <div id='options-background-dropdown' class='species-dropdown' onkeypress='toggleBackgroundList();' onclick='toggleBackgroundList();' data-intro="Change map background" data-position='left'>
                Map Background
                <div class='triangle'></div>
                <ul id='options-background-dropdown-ul'>
                  <li onkeypress='updateBaseLayer(0);' onclick='updateBaseLayer(0);'>&#10004; Park Tiles</li>
                  <li onkeypress='updateBaseLayer(1);' onclick='updateBaseLayer(1);'>Mapbox Terrain</li>
                  <li onkeypress='updateBaseLayer(2);' onclick='updateBaseLayer(2);'>Esri Topo</li>
                  <li onkeypress='updateBaseLayer(3);' onclick='updateBaseLayer(3);'>Esri Imagery</li>
                </ul>
              </div>
            </div>
            <div id='options-overlays' tooltip='Turn or off extra map features'>
              <div id='options-overlays-dropdown' class='species-dropdown' data-intro='Show extra map features' data-position='left'>
                <div onkeypress='toggleOverlayList();' onclick='toggleOverlayList();' style="color: black !important;">Map Overlays</div>
                <div onkeypress='toggleOverlayList();' onclick='toggleOverlayList();' class='triangle'></div>
                <ul id='options-overlays-dropdown-ul'>
                  <li onkeypress='toggleOverlay(0);' onclick='toggleOverlay(0);'>Trails</li>
                  <li onkeypress='toggleOverlay(1);' onclick='toggleOverlay(1);'>Visitor Centers</li>
                  <li onkeypress='toggleOverlay(2);' onclick='toggleOverlay(2);'>Shelters</li>
                  <li onkeypress='toggleOverlay(3);' onclick='toggleOverlay(3);'>Roads</li>
                  <li onkeypress='toggleOverlay(4);' onclick='toggleOverlay(4);'>Campsites</li>
                </ul>
              </div>
            </div>
          </div>

          <!--<button onkeypress='clearLayers();' onclick='clearLayers();' tooltip='Press here to remove all drawings from map'>CLEAR</button>-->
        </div>

        <div id='search-tool-extra-controls'>
          <div id='search-banner-help-share' class='bordered' tooltip='Get a shareable link'>
              <button id='search-banner-help-share-button' alt='Get a shareable link.' onclick="event.preventDefault(); alert('This is a mockup. '); return false;">
              <i class="fa fa-share-alt fades show"></i>
              <i class="fa fa-check-circle fades hide"></i>
            </button>
          </div>
          <div id='search-banner-help-link' class='bordered' tooltip='Get help using the tool'>
            <button id='search-banner-help-link-button'  onclick='alert("This is a mockup"); return false;' alt='Show the help overlay.'>?</button>
          </div>
        </div>

	</div>
</template>

<script>
export default {
  name: 'ExtraControls',
  components: {
  },
  props: {
    msg: String
  },
  data: function(){
    return {
        layers: [
        ],
        selected: ""
    }
  }
}
</script>
