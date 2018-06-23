<template>
        <transition name="subcat-slide"> 
        <div class='subcat-slide box' v-if="populated">
            <div v-if="mutableType=='categorical'" class='label'>2. Select up to two sub-categories</div>
            <div v-if="mutableType=='continuous'" class='label'>2. Select a range of values</div>
            <multiselect
                v-if="mutableType=='categorical'"
                class="subcat1"
                v-model="selected1"
                :options="mutableSubcategories"
                :close-on-select="true"
                placeholder="Select a subcategory"
                label="fullname"
                track-by="fullname"
                @input="subcatChanged1"
                :show-labels="false"
            ></multiselect>
            
            <multiselect
                v-if="mutableType=='categorical'"
                class="subcat2"
                v-model="selected2"
                :options="mutableSubcategories"
                :close-on-select="true"
                placeholder="Select a subcategory"
                label="fullname"
                track-by="fullname"
                @input="subcatChanged2"
                :show-labels="false"
            ></multiselect>

            <span v-if="mutableType=='continuous'"> 
                <div id="continuous-spectrum">
                    <div class="label continuous-block" style="background-color: rgb(231, 115, 163)">
                        <input type="checkbox" v-model="range1">{{ mutableRanges[0] }}
                    </div>
                    <div class="label continuous-block" style="background-color: rgb(180, 51, 139)">
                        <input type="checkbox" v-model="range2">{{ mutableRanges[1] }}
                    </div>
                    <div class="label continuous-block" style="background-color: rgb(110, 23, 119)">
                        <input type="checkbox" v-model="range3">{{ mutableRanges[2] }}
                    </div>
                </div>
            </span>
		</div>
        </transition>
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
            maps: {},
            populated: false,
            mutableSubcategories: this.subcategories,
            mutableType: this.type,
            mutableRanges: this.ranges
        }
    },
    methods: {
        findSubcatIndex(fullname)
        {
            for (let i in this.mutableSubcategories)
            {
                console.log(i);
                if (this.mutableSubcategories[i].fullname == fullname)
                {
                    return this.mutableSubcategories[i];
                }
            } 
            return -1;
        },
        subcatChanged1: function(){
            let index = this.findSubcatIndex(this.selected1.fullname).index;
            let name = "soil_" + index + "_1";
            this.updateLayer(name, true);
        },
        subcatChanged2: function(){
            let index = this.findSubcatIndex(this.selected2.fullname).index;
            let name = "soil_" + index + "_2";
            this.updateLayer(name, true);
        },
        updateLayer: function(environment, add){
            if (add)
            {
                let temp = L.npmap.layer.mapbox({
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
        },
        subcategories: function() {
            this.mutableSubcategories = this.subcategories;
        },
        type: function() {
            this.mutableType = this.type;
        },
        range: function() {
            this.mutableRanges = this.ranges;
        }
    },
    mounted: function()
    {
        this.$root.$on('layerChanged', (data, id) =>{
            // for example "con_slope"
            
            this.selected_layer_name = id;
            if (data.type == 'categorical')
            {
                this.mutableSubcategories = data.subcategories.map(function(d, i){
                    return {name: d.substring(0, 30) + "...", fullname: d, index: i};
                });
            }
            else
            {
                this.mutableRanges = ["0-33%", "34-66%", "67-100%"]; //data.ranges;
            }
            this.mutableType = data.type;
            for (let i in this.maps){
                NPMap.config.L.removeLayer(this.maps[i]);
                this.range1 = this.range2 = this.range3 = false;
            }
            this.populated = true;
        });
    }
}
</script>
<style>
.subcat {
  background: black;
}
.subcat1 {
  background: black;
}
.subcat2 {
  background: black;
}
.subcat1 > .multiselect__tags {
  border: 1px solid black;
  background:  #c41c8e;
}
.subcat1 > .multiselect__tags > .multiselect__single {
  background: #c41c8e;
}
.subcat1 > .multiselect__tags > span > .multiselect__single {
  background: #c41c8e;
}
.subcat1 > .multiselect__tags > .multiselect__input {
  background: #c41c8e;
}
.subcat2 > .multiselect__tags {
  border: 1px solid black;
  background:  #fd8e1f;
}
.subcat2 > .multiselect__tags > .multiselect__single {
  background: #fd8e1f;
}
.subcat2 > .multiselect__tags > span > .multiselect__single {
  background: #fd8e1f;
}
.subcat2 > .multiselect__tags > .multiselect__input {
  background: #fd8e1f;
}
.subcat-slide{
    width: 220px; 
}
.subcat-slide-enter{
    width: 0;
}
.subcat-slide-enter-to{
    transition: height .5s ease-out;
    width: 220px;
}
.subcat-slide-leave-to{
    width: 0;
    transition: width .5s ease-out;
}
</style>
