<template>
	<div class='box' style="border-right: none;">
        <div id='search-options' class='bordered'>
          <div id='search-options-left'>
            <div id='options-label label' style="color: #efefef">MAP CONTROLS</div>

            <multiselect
              class="controls"
              v-model="selectedBackgroundOption"
              :options="mapBackgroundOptions"
              :close-on-select="true"
              placeholder="Map Background"
              @input="selectBackground"
              :show-labels="false"
              :searchable="false"
              :showPointer="false"
              data-intro='Change the map background'
              data-position='right'
            />
            <multiselect
              class="controls"
              :multiple="true"
              v-model="selectedOverlayOption"
              :options="mapOverlayOptions"
              :close-on-select="false"
              placeholder="Map Overlays"
              @select="selectOverlay"
              @remove="selectOverlay"
              :show-labels="false"
              :searchable="false"
              :showPointer="false"
              data-intro='Show extra map features'
              data-position='right'
            >
              <template slot="tag" slot-scope="props"><span class="multiselect__single">Map Overlays</span></template>
            </multiselect>
          </div>

          <!--<button onkeypress='clearLayers();' onclick='clearLayers();' tooltip='Press here to remove all drawings from map'>CLEAR</button>-->
        </div>

        <div id='search-tool-extra-controls'>
          <div id='search-banner-help-share' class='bordered' tooltip='Get a shareable link'>
              <button id='search-banner-env-share-button' alt='Get a shareable link.'>
              <i class="fa fa-share-alt fades show"></i>
              <i class="fa fa-check-circle fades hide"></i>
            </button>
          </div>
          <div id='search-banner-help-link' class='bordered' tooltip='Get help using the tool'>
            <button id='search-banner-help-link-button'  onclick='showHelp();' alt='Show the help overlay.'>?</button>
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
    msg: String,
    env: String,
    observation: Boolean,
    prediction: Boolean,
    overlays: Object,
    species: String,
    subcat: Array,
    naming: String,
    background: String
  },
  data: function(){
    return {
        a: true,
        layers: [
        ],
        selected: "",
        selectedBackgroundOption: "",
        mapBackgroundOptions: ['Park Tiles', 'Mapbox Terrain', 'Esri Topo', 'Esri Imagery'],
        selectedOverlayOption: "",
        mapOverlayOptions: ['Trails', 'Visitor Centers', 'Shelters', 'Roads', 'Campsites'],
        mapOverlayOptionState: [0, 0, 0, 0, 0]
    }
  },
  mounted: function() {
      let self = this;
      let envShareButton = document.getElementById('search-banner-env-share-button');
      (new Clipboard(envShareButton, {
        text: function(trigger) {
          var settings = self.exportEnvSettings();
          console.log('in clip', settings);
          // Update window's anchor/hash
          var hash = "#" + encodeURI(JSON.stringify(settings));
          return location.href.split("#")[0] + hash;
        }
      })).on('success', function () {
        // Show success tooltip or icon change. These icons have 300ms transitions

        $('.messages').text('Share link copied to clipboard');
        $('.messages').toggleClass('hide show');

        // Hide share icon
        $('.fa-share-alt', envShareButton).toggleClass('hide show');

        // Show success icon
        window.setTimeout(function () {
          $('.fa-share-alt', envShareButton).hide();
          $('.fa-check-circle', envShareButton).show().toggleClass('hide show');
        }, 310);

        // After 1s, hide success icon
        window.setTimeout(function () {
          $('.fa-check-circle', envShareButton).toggleClass('hide show');
        }, 310 + 1000);

        // Show share icon
        window.setTimeout(function () {
          $('.fa-check-circle', envShareButton).hide();
          $('.fa-share-alt', envShareButton).show().toggleClass('hide show');
          $('.messages').toggleClass('hide show');
          //$('.messages').text('');
        }, 310 + 1000 + 310);

      });
  },
  methods: {
    selectBackground: function(option) {
      updateBaseLayer(this.mapBackgroundOptions.indexOf(option));
    },
    selectOverlay: function(option) {
      toggleOverlay(this.mapOverlayOptions.indexOf(option));
    },
    exportEnvSettings: function() {
      let settings = {};
      console.log('in export');

      if (lastBaseIndex !== 0) {
        settings.mapBackground = lastBaseIndex;
      }

      if (!showPredicted) {
        settings.showPredicted = false;
      }

      if (showObserved) {
        settings.showObserved = true;
      }
      
      if (whichName) {
        settings.whichName = whichName;
      }

      if (!blendingActive) {
        settings.blendingActive = false;
      }

      let mapOverlays = NPMap.config.overlays.filter(function(item, index) {
        return item.visible;
      }).map(function(item) { return item.name; });

      if (JSON.stringify(mapOverlays) !== '["Park Boundary"]') {
        settings.mapOverlays = mapOverlays.filter(function (option) {
          return option !== 'Park Boundary';
        });
      }

      settings.bounds = NPMap.config.L.getBounds();

      return settings;
    }
  }
}
</script>
<style>
.multiselect.controls > .multiselect__content-wrapper > .multiselect__content > .multiselect__element > .multiselect__option.multiselect__option--selected:before {
  content: "✔ ";
}
.multiselect.controls > .multiselect__tags > .multiselect__tags-wrap > .multiselect__single ~ .multiselect__single {
  display: none;
}
.multiselect.controls > .multiselect__tags > span > .multiselect__single {
  width: 80%;
}
</style>