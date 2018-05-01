<template>
  <div id="app">
    <EnvironmentsBox/>
    <SubcategoriesBox v-bind:subcategories="layers"/>
    <SpeciesBox/>
    <ExtraControls/>
  </div>
</template>

<script>
import EnvironmentsBox from './components/EnvironmentsBox.vue'
import SubcategoriesBox from './components/SubcategoriesBox.vue';
import SpeciesBox from './components/SpeciesBox.vue';
import ExtraControls from './components/ExtraControls';

export default {
    name: 'app',
    components: {
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
