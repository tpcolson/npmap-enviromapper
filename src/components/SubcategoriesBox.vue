<template>
        <div class='box'>
            <multiselect v-if="type=='categorical'" @select="subcatChanged" v-model="selected" :max="2" :options="subcategories" :multiple="true" :close-on-select="false" :clear-on-select="false" :hide-selected="true" :preserve-search="true" placeholder="Select a subcategory of the environmental layer" track-by="name" label="name">
            <template slot="tag" slot-scope="props"><span class="custom__tag"><span>{{ props.option.name }}</span><span class="custom__remove" @click="props.remove(props.option)">❌</span></span></template>

            </multiselect>

            <!--
            <select v-if="type=='categorical'" v-model="selected" v-on:change="subcatChanged">
                <option value="" disabled selected>Select a subcategory</option>
                <option v-for="subcat in subcategories">
                    {{ subcat }}
                </option>
            </select>
            -->

            <span v-if="type=='continuous'"> 
                <div class='label'>Select/deselect a range of values</div>
                <div id="continuous-spectrum">
                    <div class="label continuous-block" style="background-color: rgb(110, 23, 119)">
                        <input type="checkbox" v-model="range1" v-on:toggle>{{ ranges[0] }}</input>
                    </div>
                    <div class="label continuous-block" style="background-color: rgb(180, 51, 139)">
                        <input type="checkbox" v-model="range2">{{ ranges[1] }}</input>
                    </div>
                    <div class="label continuous-block" style="background-color: rgb(231, 115, 163)">
                        <input type="checkbox" v-model="range3">{{ ranges[2] }}</input>
                    </div>
                </div>
            </span>
		</div>
</template>

<script>
import InfoBox from './InfoBox.vue';
import Multiselect from 'vue-multiselect';


export default {
    name: 'SubcategoriesBox',
    components: {
        InfoBox,
        Multiselect
    },
    props: [
        'subcategories',
        'type', 'ranges',
        'range1', 'range2', 'range3',
        'firstflag'
    ],
    data: function(){
        return {
            selected: "",
        }
    },
    methods: {
        subcatChanged: function(subcat){
            var color = "2";
            if (this.firstflag != true)
            {
                color = "1";
                this.firstflag = true;
            }
            addEnviro("geology_" + subcat.index.toString() + "_c" + color);
        }
    },
    watch: {
        range1: function(val){
            if (val == true){
                addEnviro("slope_1_c2");
            }
        },
        range2: function(val){
            if (val == true){
                addEnviro("slope_2_c2");
            }

        },
        range3: function(val){
            if (val == true){
                addEnviro("slope_3_c2");
            }
        }
    },
    mounted: function()
    {
        this.$root.$on('layerChanged', data =>{
            if (data.type == 'categorical')
            {
                this.subcategories = data.subcategories.map(function(d, i){
                    return {name: d.substring(0, 30) + "...", fullname: d, index: i};
                });
            }
            else
            {
                this.ranges = data.ranges;
            }
            this.type = data.type;
        });
    }
}
</script>
