<template>
    <div class="species-slide box" id="species-slide">
        <div id="box">
            <div class='label' data-intro='Select a species to see how it is affected by the attribute.' data-position='top'>2. Select species affected by {{ selectedLayer }}</div>
            <img class="species-hover-thumbnail" :src="hoverImage" :style="{ top: hoverImageTopOffset + 50 + 'px', display: hoverImageDisplay, left: hoverImageLeftOffset + 'px' }">
            <multiselect
                :disabled="speciesNames.length == 0"
                v-model="selected"
                :options="speciesNames"
                :close-on-select="true"
                placeholder="Select or type a species"
                @input="speciesChanged"
                :show-labels="false"
                class="species-multiselect"
                :showPointer="false"
            >
            <p slot="noResult">No species found. Consider changing your search.</p>
            <template slot="option" slot-scope="props">
                <div class="option__species" @mouseover="mouseOverSpecies" @mouseout="mouseOutSpecies">{{ props.option }}</div>
            </template>
            </multiselect>
            <div class="progress-bar">
                <div class="progress-bar-before">Least</div>
                <div class="progress-bar-after">Most</div>
                <div class="progress-bar-percentage" style="width: 20%;"></div>
                <div class="progress-bar-percentage2" style="width: 20%;"></div>
            </div>

            <div id='checkbox-container' tooltip='Toggle the visibility of the predicted habitat'>
              <div id='options-predicted' class='search-checkbox' data-intro='Toggle the visibility of predicted and observed data.' data-position='left'>
                View:&nbsp; 
                <input type='checkbox' id='options-predicted-checkbox' onkeypress='togglePredicted();' onclick='togglePredicted();' @click="updatePrediction" checked :disabled="selected == '' || selected == null" />
                <label for='options-predicted-checkbox'>Predictions</label>&nbsp;&nbsp;
                <input type='checkbox' id='options-observed-checkbox' onkeypress='toggleObserved();' onclick='toggleObserved();' @click="updateObservation" :disabled="selected == '' || selected == null" />
                <label for='options-observed-checkbox'>Observations</label>
              </div>
                <div id='search-initial-switch' class='label' tooltip='Choose to show latin or common species names' data-intro='Choose to show common or latin names.' data-position='bottom'>
                  Name convention: 
                  <input type='radio' class='search-initial-switch-sides' id='search-name-convention-common' name='search-name-convention' onkeypress='toggleName();' onclick='toggleName();' @click="switchNameConvention($event)" checked :disabled="speciesNames.length == 0" />
                  <label for='search-name-convention-common'>Common</label>&nbsp;
                  <input type='radio' class='search-initial-switch-sides' id='search-name-convention-latin' name='search-name-convention' onkeypress='toggleName();' onclick='toggleName();' @click="switchNameConvention($event)" :disabled="speciesNames.length == 0" />
                  <label for='search-name-convention-latin'>Latin</label>
                </div>
            </div>

            <span class="sortbtns">
                <i class="fa fa-sort-amount-desc sortbtn" aria-hidden="true"></i><i class="active fa fa-sort-alpha-asc sortbtn" aria-hidden="true"></i>
            </span>
        </div>


        <span v-if="selected !== ''">
            <transition name="species-info-slide">
            <div v-show="open" class="species-info-box">
                <div class="species-info-box-title">{{ selected }}</div>
                <div style="" class="species-info-box-image">
                    <img :src="selectedImage" @click="showLargeImage = true;" />
                </div>
                <div class="info-box-info" style="">
                   <!-- The top 3 attributes that most affect this species are: -->
                   This is placeholder info about {{ selected }}
                </div>
                <!--
                <ul>
                    <li>Env. Attr. 1</li>
                    <li>Env. Attr. 2</li>
                    <li>Env. Attr. 3</li>
                </ul>
                -->
            </div>
            </transition>
            <div @click="open=!open" class="species-info-toggle">
                <div :class="{ 'triangle-closed': !open, 'triangle-open': open }" class="triangle"></div>
            </div>
        </span>
        <LargeImage :url.sync="largeImageSource" :show.sync="showLargeImage" @toggleImage="showLargeImage = false"/>
    </div>
</template>

<script>
import InfoBox from './InfoBox.vue';
import LargeImage from './LargeImage.vue';

export default {
    name: 'SpeciesBox',
    components: {
        InfoBox,
        LargeImage
    },
    props: [
        'species'
    ],
    data: function(){
        return {
            open: false,
            layers: [],
            selected: '',
            speciesNames: [],
            speciesImages: [],
            speciesTaxonomyImages: [],
            namingConvention: 'common',
            mutableSpecies: this.species,
            hoverImage: 'http://via.placeholder.com/150x150',
            hoverImageTopOffset: 0,
            hoverImageLeftOffset: 0,
            hoverImageDisplay: 'none',
            prediction: true,
            observation: false,
            selectedLayer: "...",
            largeImageSource: '',
            showLargeImage: false
        }
    },
    methods: {
        switchNameConvention: function(e) {
          if (e.target.id == 'search-name-convention-latin' && this.namingConvention == 'latin') return;
          if (e.target.id == 'search-name-convention-common' && this.namingConvention == 'common') return;
          if (this.namingConvention == 'common') {
              this.namingConvention = 'latin';
          } else {
              this.namingConvention = 'common';
          }
          this.updateNameConvention();
        },
        updateNameConvention: function() {
            this.$emit('updateNameConvention', this.namingConvention);
            if (typeof this.mutableSpecies == 'undefined' || typeof this.mutableSpecies.length == 'undefined') return;
            let element = document.getElementsByClassName('species-multiselect')[0].getElementsByClassName('multiselect__single')[0];
            let currentSpeciesName = element.innerText;
            this.speciesNames = [];
            for (var i = 0; i < this.mutableSpecies.length; i++) 
            {
                if (this.namingConvention !== 'common') {
                    let speciesName = this.mutableSpecies[i][0].replace(/_/g, ' ');
                    this.speciesNames.push(speciesName);

                    if (this.mutableSpecies[i][2] == currentSpeciesName) {
                        element.innerText = this.selected = speciesName;
                    }
                } else {
                    this.speciesNames.push(this.mutableSpecies[i][2]);

                    if (this.mutableSpecies[i][0] == currentSpeciesName.replace(/ /g, '_')) {
                        element.innerText = this.selected = this.mutableSpecies[i][2];
                    }
                }
            }
            this.$emit('updateSpecies', this.selected);
        },
        mouseOverSpecies: function(e) {
            if (this.hoverImageDisplay !== 'block') this.hoverImageDisplay = 'block';
            let speciesName = e.srcElement.innerText;
            for (let i = 0; i < this.speciesNames.length; i++) {
                if (this.speciesNames[i] == speciesName) {
                    if (this.speciesImages[speciesName] == 'http://via.placeholder.com/150x150') {
                        this.hoverImage = this.speciesTaxonomyImages[speciesName];
                    } else {
                        this.hoverImage = this.speciesImages[speciesName];
                    }
                    this.hoverImageTopOffset = i * 20;
                    break;
                }
            }
        },
        mouseOutSpecies: function(e) {
          let elem = document.getElementsByClassName('species-multiselect')[0];
          if (   e.pageX >= elem.offsetLeft + elem.offsetWidth - 20
              || e.pageX <= elem.offsetLeft + 20
              || e.pageY <= 160
              || e.pageY >= (140 + 20 * this.speciesNames.length))
          {
            this.hoverImageDisplay = 'none';
          }
        },
        speciesChanged: function(){
            this.hoverImageDisplay = 'none';
            this.selectedImage = '';
            if (this.selected == null) {
                this.$root.$emit('speciesChanged', false);
                this.$emit('updateSpecies', '');
                return;
                /* need to add removing of species layer */
            }

            let selected = this.selected;
            for (var i = 0; i < this.mutableSpecies.length; i++)
            {
                if (selected == this.mutableSpecies[i][2] || selected.replace(/ /g, '_') == this.mutableSpecies[i][0]){
                    this.$root.$emit('speciesChanged', true, this.mutableSpecies[i][0]);
                    this.$emit('updateSpecies', selected);
                    if (this.speciesImages[selected] == 'http://via.placeholder.com/150x150') {
                        this.selectedImage = this.speciesTaxonomyImages[selected];
                        this.largeImageSource = this.speciesTaxonomyImages[selected].slice(0, this.speciesTaxonomyImages[selected].length - 9) + '800px.jpg'
                    } else {
                        this.selectedImage = this.speciesImages[selected];
                        this.largeImageSource = 'http://via.placeholder.com/150x150'
                    }
                    var li = {};
                    li._id = (this.mutableSpecies[i][1]);
                    li._latin = this.mutableSpecies[i][0];
                    li._common = this.mutableSpecies[i][2];
                    selectInitialSpecies(li);
                    break;
                }
            }
        },
        updateObservation: function(observation) {
          if (typeof observation.path !== 'undefined' && typeof observation.path[0].checked !== 'undefined') {
            this.observation = observation.path[0].checked;
          } else {
            if (observation) {
              toggleObserved();
            }
            this.observation = observation;
          }
          this.$emit('updateObservation', this.observation);
        },
        updatePrediction: function(prediction) {
          if (typeof prediction.path !== 'undefined' && typeof prediction.path[0].checked !== 'undefined') {
            this.prediction = prediction.path[0].checked;
          } else {
            if (!prediction) {
              togglePredicted();
            }
            this.prediction = prediction;
          }
          this.$emit('updatePrediction', this.prediction);
        },
        loadSettings: function(envSettings) {
          if (envSettings.prediction !== null) {
            document.getElementById('options-predicted-checkbox').checked = envSettings.prediction;
            this.updatePrediction(envSettings.prediction);
          }
          if (envSettings.observation !== null) {
            document.getElementById('options-observed-checkbox') .checked = envSettings.observation;
            this.updateObservation(envSettings.observation);
          }
          if (envSettings.naming !== null) {
            this.namingConvention = envSettings.naming;
            if (envSettings.naming == 'common') {
              document.getElementById('search-name-convention-common').checked =  true;
              document.getElementById('search-name-convention-latin') .checked = false;
            } else {
              document.getElementById('search-name-convention-common').checked = false;
              document.getElementById('search-name-convention-latin') .checked =  true;
            }
            this.updateNameConvention();
          }
          if (envSettings.species !== null) {
            this.selected = envSettings.species;
            this.speciesChanged();
          }
        }
    },
    mounted: function()
    {
        this.$root.$on('layerChanged', data => {
            this.speciesNames = [];
            this.speciesImages = [];
            this.speciesTaxonomyImages = [];
            this.selected = "";
            selectInitialSpecies(null,true);
            if (data == 'removeLayer') {
                return;
            }
            this.selectedLayer = data['label'];
            this.mutableSpecies = data['related-species'];
            for (let species in this.mutableSpecies) {
              let common = this.mutableSpecies[species][2];
              let latin = this.mutableSpecies[species][0].replace(/_/g, ' ');
              if (common !== 'Unspecified') {
                if (this.namingConvention == 'common') {
                    this.speciesNames.push(common);
                } else {
                    this.speciesNames.push(latin);
                   
                }
                this.speciesImages[common] = this.mutableSpecies[species][4];
                this.speciesImages[latin] = this.mutableSpecies[species][4];
                this.speciesTaxonomyImages[common] = '/Taxonomy_Images/' + this.mutableSpecies[species][5] + '_110px.jpg';
                this.speciesTaxonomyImages[latin] = '/Taxonomy_Images/' + this.mutableSpecies[species][5] + '_110px.jpg';
              }
            }
        });
        this.$parent.$on('settingsLoaded', this.loadSettings);
    },
    watch:
    {
        species: function() {
            this.mutableSpecies = this.species;
        }
    },
    updated: function() {
      this.$nextTick(function() {
        this.hoverImageLeftOffset = this.$el.offsetLeft + 315;
      });
    }
}
</script>
<style>
.species-hover-thumbnail {
    position: absolute;
    width: 100px;
    height: 100px;
    z-index: 10000;
    -webkit-transition: top 0.1s ease;
    -o-transition: top 0.1s ease;
    transition: top 0.1s ease;
}
.species-info-box {
    background-color: #EAEAEA;
    width: 290px;
    height: 300px;
    position: relative; 
    z-index: 10000;
    color: #333;
    -webkit-box-shadow: 0 0 5px #777, inset 0 6px 3px -5px #777;
            box-shadow: 0 0 5px #777, inset 0 6px 3px -5px #777;
    border: 1px solid #999;
    border-top: 0;
    -webkit-transform: translate(0, 20px);
        -ms-transform: translate(0, 20px);
            transform: translate(0, 20px);
}
.species-info-box-title {
    font-weight: bold;
    width: 100px;
    max-width: 100px;
    padding: 10px;
    margin-bottom: 10px;
    margin-right: 10px;
    float: left;
    cursor: pointer;
}
.species-info-box-image {
    text-align: center;
    height: 200px;
    width: 150px;
}
.species-info-toggle {
    cursor: pointer;
    -webkit-transform: translate(0, 18px);
        -ms-transform: translate(0, 18px);
            transform: translate(0, 18px);
}
.speciecs-info-toggle.clicked > .triangle {
    border-top: 5px solid red;
}
.species-info-slide-enter {
    height: 0;
}
.species-info-slide-enter-to {
    -webkit-transition: height 1s ease-out;
    -o-transition: height 1s ease-out;
    transition: height 1s ease-out;
    height: 300px;
}
.species-info-slide-leave-to {
    height: 0;
    -webkit-transition: height 1s ease-out;
    -o-transition: height 1s ease-out;
    transition: height 1s ease-out;
}
.species-slide {
    width: 300px;
}
#search-options {
  padding-left: 5px;
  width: 160px;
}
.chardinjs-tooltip.chardinjs-right:before, 
.chardinjs-tooltip.chardinjs-left:after {
    width: 50px;
}
.chardinjs-tooltip.chardinjs-left:after {
    right: -35px;
}
.chardinjs-tooltip.chardinjs-left {
    margin-left: -70px;
    padding-right: 10px;
}
.chardinjs-tooltip.chardinjs-right {
    margin-right: -85px;
    padding-left: 10px;
}
.chardinjs-tooltip.chardinjs-right:before {
    left: -50px;
}
</style>
