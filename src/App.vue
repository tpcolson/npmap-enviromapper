<template>
<div>
    <div id='search-tool'>
      <div id='search-tool-contents'>
            <div id="app">
                <EnvironmentsBox 
                  v-on:updateEnv="updateEnv"
                />
                <SubcategoriesBox 
                  :subcategories="layers" 
                  v-on:updateSubCat="updateSubCat"
                />
                <SpeciesBox
                  v-on:updateSpecies="updateSpecies"
                  v-on:updatePrediction="updatePrediction"
                  v-on:updateObservation="updateObservation"
                  v-on:updateNameConvention="updateNameConvention"
                />
                <ExtraControls
                  v-on:updateOverlays="updateOverlays"
                  v-on:updateBackground="updateBackground"
                  :background.sync="background"
                  :env.sync="env"
                  :observation.sync="observation"
                  :overlays.sync="overlays"
                  :prediction.sync="prediction"
                  :species.sync="species"
                  :subcat.sync="subcat"
                  :naming.sync="naming"
                />
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
            ],
            overlays: null,
            env: '',
            subcat: null,
            species: null,
            background: 'Park Tiles',
            prediction: true,
            observation: false,
            naming: 'common'
        }
    },
    mounted: function() {
      let index, url = window.location.href, self = this;
      if ((index = url.search('#')) !== -1) {
        try {
          var settings = JSON.parse(decodeURI(url.substr(index + 1)));
        } catch (e) {
          alert('The url you entered is not valid!');
          return;
        }
        setTimeout(function() {
          let envSettings = loadEnvSettings();
          console.log(envSettings);
          self.$root.$emit('settingsLoaded', envSettings);
        }, 1000);
      }
    },
    methods: {
      updateEnv: function(selectedEnv) {
        this.env = selectedEnv;
      },
      updateSubCat: function(selectedSubCat) {
        this.subcat = selectedSubCat;
      },
      updateSpecies: function(selectedSpecies) {
        console.log(selectedSpecies);
        this.species = selectedSpecies;
      },
      updateOverlays: function(selectedOverlays) {
        console.log(selectedOverlays);
        this.overlays = selectedOverlays;
      },
      updateBackground: function (selectedBackground) {
        console.log(selectedBackground);
        this.background = selectedBackground;
      },
      updatePrediction: function (selectedPrediction) {
        console.log(selectedPrediction);
        this.prediction = selectedPrediction;
      },
      updateObservation: function (selectedObservation) {
        console.log(selectedObservation);
        this.observation = selectedObservation;
      },
      updateNameConvention: function (namingConvention) {
        console.log(namingConvention);
        this.naming = namingConvention;
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
