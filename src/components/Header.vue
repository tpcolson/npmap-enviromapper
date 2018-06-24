<template>
  <div>
    <div class="left">
      <a id="title" href = "https://www.nps.gov/grsm/learn/nature/index.htm" style="text-decoration: none" target="_blank"> 
        <h1> Great Smoky Mountains National Park</h1>
      </a>
      <div id="atlas-app-changer">
        <multiselect
          class="header-selector"
          v-model="selected"
          :options="options"
          :close-on-select="true"
          placeholder="Atlas of the Smokies"
          :show-labels="false"
          @input="appSelect"
        />
      </div>
    </div>
    <div class="right">
      <h2>National Park Service<br>U.S. Department of the Interior</h2>
      <span class="arrowhead"></span>
    </div>
  </div>
</template>

<script>
import Multiselect from 'vue-multiselect';

export default {
  name: 'Header',
  components: {
    Multiselect
  },
  data: function() {
    return {
      options: ['Environment Mapper', 'Species Mapper'],
      selected: ''
    }
  },
  methods: {
    appSelect: function (selection) {
      if (selection == 'Species Mapper') appChange();
    }
  }
}
</script>
<style>
.header-selector {
  width: 170px;
  display: inline-block;
  position: relative;
  top: -12px;
}
.multiselect--active {
  z-index: 1000000000;
}
.multiselect--active > .multiselect__content-wrapper {
  margin-top: 0px;
}
header .left h1, header .left div {
  overflow: visible !important;
}
</style>