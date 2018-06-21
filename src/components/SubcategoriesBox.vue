<template>
        <transition name="subcat-slide"> 
        <div class='subcat-slide box' v-if="populated">
            <div v-if="type=='categorical'" class='label'>2. Select up to two sub-categories</div>
            <div v-if="type=='continuous'" class='label'>2. Select a range of values</div>
            <multiselect
                v-if="type=='categorical'"
                class="subcat1"
                v-model="selected1"
                :options="subcategories"
                :close-on-select="true"
                placeholder="Select a subcategory"
                label="fullname"
                track-by="fullname"
                @input="subcatChanged1"
                :show-labels="false"
            ></multiselect>
            
            <multiselect
                v-if="type=='categorical'"
                class="subcat2"
                v-model="selected2"
                :options="subcategories"
                :close-on-select="true"
                placeholder="Select a subcategory"
                label="fullname"
                track-by="fullname"
                @input="subcatChanged2"
                :show-labels="false"
            ></multiselect>

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
            populated: false
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
            var index = this.findSubcatIndex(this.selected1.fullname).index;
            var name = "soil_" + index + "_1";
            this.updateLayer(name, true);
        },
        subcatChanged2: function(subcat){
            var index = this.findSubcatIndex(this.selected2.fullname).index;
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
  min-height: 40px;
  display: block;
  padding: 8px 40px 0 8px;
  border-radius: 5px;
  border: 1px solid black;
  background:  #c41c8e;
  font-size: 14px;
}
.subcat1 > .multiselect__tags > .multiselect__single {
  position: relative;
  display: inline-block;
  min-height: 20px;
  line-height: 20px;
  border: none;
  border-radius: 5px;
  background: #c41c8e;
  padding: 0 0 0 5px;
  width: calc(100%);
  transition: border 0.1s ease;
  box-sizing: border-box;
  margin-bottom: 8px;
  vertical-align: top;
}
.subcat1 > .multiselect__tags > span > .multiselect__single {
  position: relative;
  display: inline-block;
  min-height: 20px;
  line-height: 20px;
  border: none;
  border-radius: 5px;
  background: #c41c8e;
  padding: 0 0 0 5px;
  width: calc(100%);
  transition: border 0.1s ease;
  box-sizing: border-box;
  margin-bottom: 8px;
  vertical-align: top;
}
.subcat1 > .multiselect__tags > .multiselect__input {
  position: relative;
  display: inline-block;
  min-height: 20px;
  line-height: 20px;
  border: none;
  border-radius: 5px;
  background: #c41c8e;
  padding: 0 0 0 5px;
  width: calc(100%);
  transition: border 0.1s ease;
  box-sizing: border-box;
  margin-bottom: 8px;
  vertical-align: top;
}
.subcat2 > .multiselect__tags {
  min-height: 40px;
  display: block;
  padding: 8px 40px 0 8px;
  border-radius: 5px;
  border: 1px solid black;
  background:  #fd8e1f;
  font-size: 14px;
}
.subcat2 > .multiselect__tags > .multiselect__single {
  position: relative;
  display: inline-block;
  min-height: 20px;
  line-height: 20px;
  border: none;
  border-radius: 5px;
  background: #fd8e1f;
  padding: 0 0 0 5px;
  width: calc(100%);
  transition: border 0.1s ease;
  box-sizing: border-box;
  margin-bottom: 8px;
  vertical-align: top;
}
.subcat2 > .multiselect__tags > span > .multiselect__single {
  position: relative;
  display: inline-block;
  min-height: 20px;
  line-height: 20px;
  border: none;
  border-radius: 5px;
  background: #fd8e1f;
  padding: 0 0 0 5px;
  width: calc(100%);
  transition: border 0.1s ease;
  box-sizing: border-box;
  margin-bottom: 8px;
  vertical-align: top;
}
.subcat2 > .multiselect__tags > .multiselect__input {
  position: relative;
  display: inline-block;
  min-height: 20px;
  line-height: 20px;
  border: none;
  border-radius: 5px;
  background: #fd8e1f;
  padding: 0 0 0 5px;
  width: calc(100%);
  transition: border 0.1s ease;
  box-sizing: border-box;
  margin-bottom: 8px;
  vertical-align: top;
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
