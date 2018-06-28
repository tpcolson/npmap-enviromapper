<template>
    <div class="species-slide box">
        <div id="box">
            <div class='label' data-intro='Select a species to see how it has been affected' data-position='top'>3. Select an affected species</div>
            <img class="species-hover-thumbnail" :src="hoverImage" :style="{ top: hoverImageTopOffset + 50 + 'px', display: hoverImageDisplay }">
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
              <div id='options-predicted' class='search-checkbox' data-intro='Toggle the visibility of predicted and observed data' data-position='left'>
                View:&nbsp; 
                <input type='checkbox' id='options-predicted-checkbox' onkeypress='togglePredicted();' onclick='togglePredicted();' checked disabled />
                <label for='options-predicted-checkbox'>Predictions</label>&nbsp;&nbsp;
                <input type='checkbox' id='options-observed-checkbox' onkeypress='toggleObserved();' onclick='toggleObserved();' disabled />
                <label for='options-observed-checkbox'>Observations</label>
              </div>
                <div id='search-initial-switch' class='label' tooltip='Choose to show latin or common species names' data-intro='Choose to show common or latin names' data-position='bottom'>
                  View name as:
                  <input type='radio' class='search-initial-switch-sides' id='search-name-convention-common' name='search-name-convention' onkeypress='toggleName();' onclick='toggleName();' v-on:click="changeNames($event)" checked :disabled="speciesNames.length == 0" />
                  <label for='search-name-convention-common'>Common</label>&nbsp;
                  <input type='radio' class='search-initial-switch-sides' id='search-name-convention-latin' name='search-name-convention' onkeypress='toggleName();' onclick='toggleName();' v-on:click="changeNames($event)" :disabled="speciesNames.length == 0" />
                  <label for='search-name-convention-latin'>Latin</label>
                </div>
            </div>

            <span class="sortbtns">
                <i class="fa fa-sort-amount-desc sortbtn" aria-hidden="true"></i><i class="active fa fa-sort-alpha-asc sortbtn" aria-hidden="true"></i>
            </span>
        </div>


        <span v-if="selected !== null">
            <transition name="species-info-slide">
            <div v-show="open" class="species-info-box">
                <div class="species-info-box-title">{{ selected }}</div>
                <div style="" class="species-info-box-image">
                    <img src="http://via.placeholder.com/150x150" />
                </div>
                <div class="info-box-info">
                    The top 3 attributes that most affect this species are: 
                </div>
                <ul>
                    <li>Env. Attr. 1</li>
                    <li>Env. Attr. 2</li>
                    <li>Env. Attr. 3</li>
                </ul>
            </div>
            </transition>
            <div @click="open=!open" class="species-info-toggle">
                <div :class="{ 'triangle-closed': !open, 'triangle-open': open }" class="triangle"></div>
            </div>
        </span>
    </div>
</template>

<script>
import InfoBox from './InfoBox.vue';

export default {
    name: 'SpeciesBox',
    components: {
        InfoBox
    },
    props: [
        'species'
    ],
    data: function(){
        return {
            open: false,
            layers: [],
            selected: null,
            speciesNames: [],
            speciesImages: [],
            namingConvention: 'common',
            mutableSpecies: this.species,
            hoverImage: 'http://via.placeholder.com/150x150',
            hoverImageTopOffset: 0,
            hoverImageDisplay: 'none'
        }
    },
    methods: {
        changeNames: function(e) {
            if (e.target.id == 'search-name-convention-latin' && this.namingConvention == 'latin') return;
            if (e.target.id == 'search-name-convention-common' && this.namingConvention == 'common') return;
            if (this.namingConvention == 'common') {
                this.namingConvention = 'latin';
            } else {
                this.namingConvention = 'common';
            }
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
        },
        mouseOverSpecies: function(e) {
            if (this.hoverImageDisplay !== 'block') this.hoverImageDisplay = 'block';
            let speciesName = e.srcElement.innerText;
            for (let i = 0; i < this.speciesNames.length; i++) {
                if (this.speciesNames[i] == speciesName) {
                    this.hoverImage = this.speciesImages[speciesName];
                    this.hoverImageTopOffset = i * 20;
                    break;
                }
            }
        },
        mouseOutSpecies: function(e) {
            if (   e.pageX >= 840
                || e.pageX <= 640
                || e.pageY < 160
                || e.pageY > (140 + 20 * this.speciesNames.length))
            {
                this.hoverImageDisplay = 'none';
            }
        },

        speciesChanged: function(){
            if (this.selected == null) {
                this.$root.$emit('speciesChanged', false);
                return;
                /* need to add removing of species layer */
            }
            this.$root.$emit('speciesChanged', true);
            for (var i = 0; i < this.mutableSpecies.length; i++)
            {
                let selected = this.selected;
                if (selected == this.mutableSpecies[i][2] || selected.replace(/ /g, '_') == this.mutableSpecies[i][0]){
                    var li = {};
                    li._id = (this.mutableSpecies[i][1]);
                    li._latin = this.mutableSpecies[i][0];
                    li._common = this.mutableSpecies[i][2];
                    selectInitialSpecies(li);
                    break;
                }
            }
        }
    },
    mounted: function()
    {
        this.$root.$on('layerChanged', data => {
            this.speciesNames = [];
            this.speciesImages = [];
            if (data == 'removeLayer') {
                this.selected = null;
                return;
            }
            this.mutableSpecies = data['related-species'];
            for (let species in this.mutableSpecies) {
                if (this.namingConvention == 'common') {
                    this.speciesNames.push(this.mutableSpecies[species][2]);
                } else {
                    let speciesName = this.mutableSpecies[species][0].replace(/_/g, ' ');
                    this.speciesNames.push(speciesName);
                   
                }
                this.speciesImages[this.mutableSpecies[species][2]] = this.mutableSpecies[species][4];
                this.speciesImages[this.mutableSpecies[species][0].replace(/_/g, ' ')] = this.mutableSpecies[species][4];
            }
        });
    },
    watch:
    {
        species: function() {
            this.mutableSpecies = this.species;
        }
    }
}
</script>
<style>
.species-hover-thumbnail {
    position: absolute;
    left: 855px;
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
    height: 150px;
    width: 150px;
}
.species-info-toggle {
    cursor: pointer;
    -webkit-transform: translate(0, 20px);
        -ms-transform: translate(0, 20px);
            transform: translate(0, 20px);
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
