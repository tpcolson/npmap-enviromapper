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
                :showPointer="false"
            />
            
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
                :showPointer="false"
            />

            <span v-if="mutableType=='continuous'"> 
                <div id="continuous-spectrum">
                    <div class="label continuous-block" style="background-color: rgb(231, 115, 163)">
                        <input type="checkbox" v-model="range1">{{ mutableRanges[0] }}
                    </div>
                    <div class="label continuous-block" style="background-color: rgb(180, 51, 139)">
                        <input type="checkbox" v-model="range2">{{ mutableRanges[1] }}
                    </div>
                    <div class="label continuous-block" style="width: 73px; background-color: rgb(110, 23, 119)">
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
        'firstflag'
    ],
    data: function(){
        return {
            selected1: "",
            oldSelected1: "",
            selected2: "",
            oldSelected2: "",
            maps: {},
            populated: false,
            mutableSubcategories: this.subcategories,
            mutableType: this.type,
            mutableRanges: this.ranges,
            range1: null,
            range2: null,
            range3: null
        }
    },
    methods: {
        findSubcatIndex(fullname)
        {
            for (let i in this.mutableSubcategories)
            {
                if (this.mutableSubcategories[i].fullname == fullname)
                {
                    return this.mutableSubcategories[i];
                }
            } 
            return -1;
        },
        subcatChange: function (value, subcatNumber) {
            if (value == null) value = { fullname: 'null' };
            this.$root.$emit('subcatChanged', value.fullname, subcatNumber);
            let s1 = (this.selected1 == null) ? '' : this.selected1.fullname;
            let s2 = (this.selected2 == null) ? '' : this.selected2.fullname;
            this.$emit('updateSubCat', [s1, s2]);
        },
        subcatChanged1: function(value){
            this.subcatChange(value, 1);
            let index, name;
            if (this.oldSelected1 !== '') {
                index = this.findSubcatIndex(this.oldSelected1.fullname).index;
                name = "soil_" + index + "_1";
                this.updateLayer(name, false);
            }
            let fullname = (value == null) ? this.oldSelected1.fullname : this.selected1.fullname;
            index = this.findSubcatIndex(fullname).index;
            name = "soil_" + index + "_1";
            let add = (value == null) ? false : true;
            this.updateLayer(name, add);
            if (value !== null) this.oldSelected1 = this.selected1;
        },
        subcatChanged2: function(value){
            this.subcatChange(value, 2);
            let index, name;
            if (this.oldSelected2 !== '') {
                index = this.findSubcatIndex(this.oldSelected2.fullname).index;
                name = "soil_" + index + "_2";
                this.updateLayer(name, false);
            }
            let fullname = (value == null) ? this.oldSelected2.fullname : this.selected2.fullname;
            index = this.findSubcatIndex(fullname).index;
            name = "soil_" + index + "_2";
            let add = (value == null) ? false : true;
            this.updateLayer(name, add);
            if (value !== null) this.oldSelected2 = this.selected2;
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
        },
        loadSettings: function(envSettings) {
          if (envSettings.subcat !== null) {
            for (let i = 0; i < this.mutableSubcategories.length; i++) {
              let subcat = this.mutableSubcategories[i];
              if (subcat.fullname == envSettings.subcat[0]) {
                this.selected1 = subcat;
                this.subcatChanged1(subcat);
              }
              if (subcat.fullname == envSettings.subcat[1]) {
                this.selected2 = subcat;
                this.subcatChanged2(subcat);
              }
            }
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
            if (data == 'removeLayer') {
                this.populated = false;
                return;
            }
            // for example "con_slope"
            this.selected_layer_name = id;
            if (data.type == 'categorical')
            {
                this.mutableSubcategories = data.subcategories.map(function(d, i){
                    return {name: d.name.substring(0, 30) + "...", fullname: d.name, index: i};
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

        this.$parent.$on('settingsLoaded', this.loadSettings);
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
.subcat-slide {
    width: 220px;
}
.subcat-slide-enter {
    width: 0;
}
.subcat-slide-enter-to {
    -webkit-transition: all 1s ease-out;
    -o-transition: all 1s ease-out;
    transition: all 1s ease-out;
    width: 220px;
}
.subcat-slide-leave-to {
    width: 0px;
    padding: 0px;
    -webkit-transition: all 1s ease-in;
    -o-transition: all 1s ease-in;
    transition: all 1s ease-in;
}
.subcat-slide-enter-active,
.subcat-slide-leave-active {
  overflow: hidden;
  white-space: nowrap;
}

.subcat-slide-enter-active > .multiselect > .multiselect__select,
.subcat-slide-leave-active > .multiselect > .multiselect__select {
  display: none;
}
</style>
