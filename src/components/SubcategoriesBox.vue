<template>
        <div class='box'>
            <div v-if="type=='categorical'" class='label'>2. Select upto two sub-categories</div>
            <div v-if="type=='continuous'" class='label'>2. Select a range of values</div>
            <select class="subcat subcat1" v-if="type=='categorical'" v-model="selected1" v-on:change="subcatChanged1" label="name">
                <option value="" disabled selected>Select a subcategory</option>
                <option v-for="item in subcategories">
                    {{ item.fullname }}
                </option>
            </select>      

            <select class="subcat subcat2" v-if="type=='categorical'" v-model="selected2" v-on:change="subcatChanged2" label="name">
                <option value="" disabled selected>Select another</option>
                <option v-for="item in subcategories">
                    {{ item.fullname }}
                </option>
            </select>      

            <!--
            <multiselect v-if="type=='categorical'" @select="subcatChanged" v-model="selected" :max="2" :options="subcategories" :multiple="true" :close-on-select="false" :clear-on-select="false" :hide-selected="true" :preserve-search="true" placeholder="Select a subcategory of the environmental layer" track-by="name" label="name">
            <template slot="tag" slot-scope="props"><span class="custom__tag"><span>{{ props.option.name }}</span><span class="custom__remove" @click="props.remove(props.option)">❌</span></span></template>

            </multiselect>
            -->

            <span v-if="type=='continuous'"> 
                <div id="continuous-spectrum">
                    <div class="label continuous-block" style="background-color: rgb(231, 115, 163)">
                        <input type="checkbox" v-model="range1">{{ ranges[0] }}
                    </div>
                    <div class="label continuous-block" style="background-color: rgb(180, 51, 139)">
                        <input type="checkbox" v-model="range2">{{ ranges[1] }}
                    </div>
                    <div class="label continuous-block" style="background-color: rgb(110, 23, 119)">
                        <input type="checkbox" v-model="range3" v-on:toggle>{{ ranges[2] }}
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
            selected1: "",
            selected2: "",
            maps: {}
        }
    },
    methods: {
        findSubcatIndex(fullname)
        {
            for (var i in this.subcategories)
            {
                if (this.subcategories[i].fullname == fullname)
                {
                    return this.subcategories[i];
                }
            } 
            return -1;
        },
        subcatChanged1: function(subcat){
            var index = this.findSubcatIndex(this.selected1).index; 
            var name = "soil_" + index + "_1";
            this.updateLayer(name, true);
        },
        subcatChanged2: function(subcat){
            var index = this.findSubcatIndex(this.selected2).index;
            var name = "soil_" + index + "_2";
            this.updateLayer(name, true);
        },
        updateLayer: function(environment, add){
            if (add)
            {
                var temp = L.npmap.layer.mapbox({
                    name: environment,
                    opacity: .5, //blendingActive ? .5 : 1,
                    id: 'mahmadza.GRSM_' + environment
                });
                this.maps[environment] = temp.addTo(NPMap.config.L)
            }
            else
            {
                NPMap.config.L.removeLayer(this.maps[environment]);
            }
        }
    },
    watch: {
        range1: function(val) {
            this.updateLayer(this.selected_layer_name + "_0", val);
        },
        range2: function(val) {
            this.updateLayer(this.selected_layer_name + "_1", val);
        },
        range3: function(val) {
            this.updateLayer(this.selected_layer_name + "_2", val);
        }
    },
    mounted: function()
    {
        this.$root.$on('layerChanged', (data, id) =>{
            // for example "con_slope"
            this.selected_layer_name = id;
            if (data.type == 'categorical')
            {
                this.subcategories = data.subcategories.map(function(d, i){
                    return {name: d.substring(0, 30) + "...", fullname: d, index: i};
                });
            }
            else
            {
                this.ranges = ["0-33%", "34-66%", "67-100%"]; //data.ranges;
            }
            this.type = data.type;
            for (i in this.maps){
                NPMap.config.L.removeLayer(this.maps[i]);
                this.range1 = this.range2 = this.range3 = false;
            }
        });
    }
}
</script>
