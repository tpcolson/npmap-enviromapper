<template>
    <div class="box" style="width: 290px;">
        <div id="box"> 
            <div class='label'>3. Select an affected species</div>
            <select v-model="selected" v-on:change="speciesChanged">
                <option value="" disabled selected>Select or type a species</option>
                <option v-for="s in species">
                    {{ s[2] }}
                </option>
            </select>
            <div id='search-initial-altname'></div>
            <div class="progress-bar">
                <div class="progress-bar-before">Least</div>
                <div class="progress-bar-after">Most</div>
                <div class="progress-bar-percentage" style="width: 20%;"></div>
                <div class="progress-bar-percentage2" style="width: 20%;"></div>
            </div>

            <div id='checkbox-container' tooltip='Toggle the visibility of the predicted habitat' data-intro='Toggle visibility of predicted and observed data' data-position='bottom'>
              <div id='options-predicted' class='search-checkbox'>
                View:&nbsp; 
                <input type='checkbox' id='options-predicted-checkbox' onkeypress='togglePredicted();' onclick='togglePredicted();' checked disabled></input>
                <label for='options-predicted-checkbox'>Predictions</label>&nbsp;&nbsp;
                <input type='checkbox' id='options-observed-checkbox' onkeypress='toggleObserved();' onclick='toggleObserved();' disabled></input>
                <label for='options-observed-checkbox'>Observations</label>
              </div>
                <div id='search-initial-switch' class='label' tooltip='Choose to show latin or common species names' data-intro='Choose to show common or latin names' data-position='bottom'>
                  View affected species as:&nbsp; 
                  <input type='radio' class='search-initial-switch-sides' id='search-name-convention-common' name='search-name-convention' onkeypress='toggleName();' onclick='toggleName();' checked></input>
                  <label for='search-name-convention-common'>Common</label>&nbsp;&nbsp;
                  <input type='radio' class='search-initial-switch-sides' id='search-name-convention-latin' name='search-name-convention' onkeypress='toggleName();' onclick='toggleName();' ></input>
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
            selected: ""
        }
    },
    methods: {
        speciesChanged: function(){
            for (var i = 0; i < this.species.length; i++)
            {
                if (this.selected == this.species[i][2]){
                    var li = {};
                    li._id = (this.species[i][1]);
                    li._latin = this.species[i][0];
                    li._common = this.species[i][2];
                    selectInitialSpecies(li);
                }
            }
        }
    },
    mounted: function()
    {
        this.$root.$on('layerChanged', data => {
            this.species = data['related-species'];
        });
    } 
}
</script>
