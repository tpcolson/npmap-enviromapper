<template>
  <div id='color-legend' v-show="show">
    <div id='legend-banner'>
      <div id='legend-banner-left'>SPECIES DENSITY</div>
      <div id='legend-banner-right'>MODEL CONFIDENCE</div>
    </div>
    <ol id='legend-species'>
      
      <li id='legend-species-blue'>
        <div id='legend-blue-controls'>
          <div alt='Reorder species layers' class='drag-handle' tooltip='Drag this to reorder the layers. To bring this layer to the front, drag this row to the top of the legend'>::</div>
          <label for='toggle-species-three' class='hidden-label'>Toggle Species Visibility</label>
          <input id='toggle-species-three' type='checkbox' onkeypress='toggleSpecies(2);' onclick='toggleSpecies(2);' checked tooltip='Use this to toggle the visibility of this species' disabled />
        </div>
        <div id='legend-blue-contents' tooltip='Percentages correspond to the predicted likelihood of the species living in an area'>
          <div id='legend-blue-contents-name'>Species 1</div>
          <div id='legend-blue-contents-colormap'>
            <div id='legend-blue-100'>100-75%</div>
            <div id='legend-blue-75'>75-50%</div>
            <div id='legend-blue-50'>50-25%</div>
          </div>
        </div>
        <div id='legend-blue-quality' tooltip='Model confidence represents how correct the shown prediction layer is believed to be'>Placeholder Quality</div>
      </li>
    </ol>
    <div id='legend-blend' tooltip='When on, predicted data layers are shown at 50% opacity to show areas of overlap. When off, predicted layers are shown at 100% opacity'>
      <div id='legend-blend-text'>COLOR BLEND:</div>
      <div id='legend-blend-switch'>
        <div class='legend-blend-switch-sides'><div onkeypress='toggleBlending();' onclick='toggleBlending();'>ON</div></div>
        <div class='legend-blend-switch-sides'><div onkeypress='toggleBlending();' onclick='toggleBlending();'>OFF</div></div>
        <div id='legend-blend-switch-button'><div onkeypress='toggleBlending();' onclick='toggleBlending();'><span>...</span></div></div>
      </div>
    </div>
  </div>
</template>

<script>

export default {
  name: 'SpeciesDensity',
  data: function () {
    return {
      show: false
    }
  },
  mounted: function () {
    this.$root.$on('speciesChanged', show => {
      this.show = show;
    });
  }
}

</script>

<style>
#color-legend {
  display: inline-block;
}
#color-legend > ol {
  list-style: none;
  margin: 0;
  padding: 0;
  border: 0;
  font-size: 100%;
  font: inherit;
  vertical-align: baseline;
}
</style>