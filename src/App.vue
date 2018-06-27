<template>
<div>
    <div id='search-tool'>
      <div id='search-tool-contents'>
            <div id="app">
                <EnvironmentsBox/>
                <SubcategoriesBox v-bind:subcategories="layers"/>
                <SpeciesBox/>
                <ExtraControls/>
            </div>
      </div>
    </div>
    <SpeciesDensity></SpeciesDensity>
</div>
</template>

<script>
import SpeciesDensity from './components/SpeciesDensity.vue'
import EnvironmentsBox from './components/EnvironmentsBox.vue'
import SubcategoriesBox from './components/SubcategoriesBox.vue';
import SpeciesBox from './components/SpeciesBox.vue';
import ExtraControls from './components/ExtraControls';

export default {
    name: 'app',
    components: {
        SpeciesDensity,
        EnvironmentsBox,
        SubcategoriesBox,
        SpeciesBox,
        ExtraControls
    },
    data: function(){
        return {
            layers: [
                1, 2, 3, 4
            ]
        }
    }
}
</script>

<style>
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
}
</style>
