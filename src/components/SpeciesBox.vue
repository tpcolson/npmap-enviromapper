<template>
    <div class="box" style="width: 290px;">
        <div id="box">
            <div class='label'>3. Select an affected species</div>
            <multiselect
                v-model="selected"
                :options="speciesNames"
                :close-on-select="true"
                placeholder="Select or type a species"
                @input="speciesChanged"
                :show-labels="false"
                class="species-multiselect"
            >
            <p slot="noResult">No species found. Consider changing your search.</p>
            
            </multiselect>
            <div class="progress-bar">
                <div class="progress-bar-before">Least</div>
                <div class="progress-bar-after">Most</div>
                <div class="progress-bar-percentage" style="width: 20%;"></div>
                <div class="progress-bar-percentage2" style="width: 20%;"></div>
            </div>

            <div id='checkbox-container' tooltip='Toggle the visibility of the predicted habitat' data-intro='Toggle visibility of predicted and observed data' data-position='bottom'>
              <div id='options-predicted' class='search-checkbox'>
                View:&nbsp; 
                <input type='checkbox' id='options-predicted-checkbox' onkeypress='togglePredicted();' onclick='togglePredicted();' checked disabled />
                <label for='options-predicted-checkbox'>Predictions</label>&nbsp;&nbsp;
                <input type='checkbox' id='options-observed-checkbox' onkeypress='toggleObserved();' onclick='toggleObserved();' disabled />
                <label for='options-observed-checkbox'>Observations</label>
              </div>
                <div id='search-initial-switch' class='label' tooltip='Choose to show latin or common species names' data-intro='Choose to show common or latin names' data-position='bottom'>
                  View name as:&nbsp; 
                  <input type='radio' class='search-initial-switch-sides' id='search-name-convention-common' name='search-name-convention' onkeypress='toggleName();' onclick='toggleName();' v-on:click="changeNames($event)" checked />
                  <label for='search-name-convention-common'>Common</label>&nbsp;&nbsp;
                  <input type='radio' class='search-initial-switch-sides' id='search-name-convention-latin' name='search-name-convention' onkeypress='toggleName();' onclick='toggleName();' v-on:click="changeNames($event)" />
                  <label for='search-name-convention-latin'>Latin</label>
                </div>
            </div>

            <span class="sortbtns">
                <i class="fa fa-sort-amount-desc sortbtn" aria-hidden="true"></i><i class="active fa fa-sort-alpha-asc sortbtn" aria-hidden="true"></i>
            </span>
        </div>


        <span v-if="false">
            <div class="species-info-box">
                <div style="" class="info-box-image"></div>  
                <div class="info-box-info">
                    The top 3 attributes that most affect this species are: 
                </div>
                <ul>
                    <li>Env. Attr. 1</li>
                    <li>Env. Attr. 1</li>
                    <li>Env. Attr. 1</li>
                    <li>Env. Attr. 1</li>
                </ul>
            </div>
            <div class="species-info-toggle">
                <div class="triangle"></div>
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
            layers: [
            ],
            selected: "",
            speciesNames: [],
            namingConvention: 'common',
            mutableSpecies: this.species
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

        speciesChanged: function(){
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
            this.mutableSpecies = data['related-species'];
            this.speciesNames = [];
            for (let species in this.mutableSpecies) {
                if (this.namingConvention == 'common') {
                    this.speciesNames.push(this.mutableSpecies[species][2]);
                } else {
                    let speciesName = this.mutableSpecies[species][0].replace(/_/g, ' ');
                    this.speciesNames.push(speciesName);
                }
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
.species-info-toggle {
    cursor: pointer; 
}
.speciecs-info-toggle.clicked > .triangle {
    border-top: 5px solid red;
}
</style>
