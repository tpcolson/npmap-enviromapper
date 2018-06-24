<template>
	<div class='box' style="border-right: none;">
        <div id='search-options' class='bordered'>
          <div id='search-options-left'>
            <div id='options-label label' style="color: #efefef">MAP CONTROLS</div>

            <multiselect
              v-model="selectedBackgroundOption"
              :options="mapBackgroundOptions"
              :close-on-select="true"
              placeholder="Map Background"
              @input="selectBackground"
              :show-labels="false"
              :searchable="false"
            />
            <multiselect
              :multiple="true"
              v-model="selectedOverlayOption"
              :options="mapOverlayOptions"
              :close-on-select="false"
              placeholder="Map Overlays"
              @select="selectOverlay"
              @remove="selectOverlay"
              :show-labels="false"
              :searchable="false"
              :hideSelected="true"
            />

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
        selected: "",
        selectedBackgroundOption: "",
        mapBackgroundOptions: ['Park Tiles', 'Mapbox Terrain', 'Esri Topo', 'Esri Imagery'],
        selectedOverlayOption: "",
        mapOverlayOptions: ['Trails', 'Visitor Centers', 'Shelters', 'Roads', 'Campsites']
    }
  },
  methods: {
    selectBackground: function(option) {
      updateBaseLayer(this.mapBackgroundOptions.indexOf(option));
    },
    selectOverlay: function(option) {
      toggleOverlay(this.mapOverlayOptions.indexOf(option));
    }
  }
}
</script>