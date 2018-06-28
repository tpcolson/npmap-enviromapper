<template>
	<div class='box' style="border: none;" data-intro='Pick an environmental layer to see it on the map' data-position='top'>
		<div class='label'>1. Select an environmental attribute</div>
        <multiselect
            v-model="selected"
            :options="layersArray"
            placeholder="Select a layer"
            @input="layerChanged"
            label="label"
            track-by="label"
            :showLabels="false"
            :showPointer="false"
        />
		<InfoBox :layer="layersForSubCat" />
	</div>
</template>

<script>
import InfoBox from './InfoBox.vue';

export default {
    name: 'EnvironmentsBox',
    components: {
      InfoBox
    },
    data: function(){
        return {
            layersArray: [],
            layersObject: {},
            selected: "",
            layersForSubCat: {}
        }
    },
    methods: {
        layerChanged: function(){
            if (this.$data.selected == null) {
                this.$root.$emit('layerChanged', 'removeLayer', null);
                return;
            }
            let selected;
            for (let key in this.layersArray) {
                if (this.layersArray[key].name == this.$data.selected.name) { 
                    selected = key; 
                    break;
                } 
            }
            for (let key in this.$data.layersObject) {
                if (this.$data.layersArray[selected].name == this.$data.layersObject[key].name) {
                    this.layersForSubCat = this.$data.layersArray[selected];
                    this.$root.$emit('layerChanged', this.$data.layersArray[selected], 
                        key);
                    break;
                }
            }
            
        }
    },
    mounted: function()
    {
        var self = this;
        $.ajax({
            url: 'data.json',
            method: 'GET',
            success: function(data)
            {
                self.layersArray = Object.values(data);
                self.layersObject = data;
                for (let key in self.layersArray) { 
                    let layer = self.layersArray[key]; 
                    if (layer.subcategories.length > 0 || layer.type == 'continuous') { 
                        self.layersArray[key].label = layer.name;
                    } 
                    if (layer.subcategories.length == 0 && layer.type == 'categorical') { 
                        self.layersArray[key].label = '-' + layer.name;
                    }
                }
            }
      });
    }
}
</script>
<style>

.multiselect,
.multiselect .subcat1 {
    min-height: 18px;
    margin-bottom: 7px;
    font-size: 13px !important;
    border: black;
    color: #f5faf2;
    max-height: none;
}
.multiselect__tags {
    padding: 0;
    min-height: 18px;
    max-height: 25px;
    border-radius: 3px;
    background-color: rgb(64, 64, 61);
    border: black;
    color: #f5faf2;
    cursor: text;
}
.multiselect__select {
    padding: 0;
    height: 18px;
    -webkit-transition: -webkit-transform 1s ease;
    transition: -webkit-transform 1s ease;
    -o-transition: transform 1s ease;
    transition: transform 1s ease;
    transition: transform 1s ease, -webkit-transform 1s ease;
    display: block;
}
.multiselect--active .multiselect__select {
  -webkit-transform: rotateZ(-180deg);
      -ms-transform: rotate(-180deg);
          transform: rotateZ(-180deg);
}
.multiselect__select:before {
    z-index: 10000000;
    top: 12px;
}
.multiselect__input,
.multiselect__single {
  width: 85%;
}

.multiselect--disabled > .multiselect__tags > span > .multiselect__single {
  width: 100%;
}
.multiselect__element {
    height: 20px;
    margin: 0px;
    cursor: pointer;
    font-size: 10pt;
    font-style: italic;
    line-height: 20px;
    color: #f5faf2 !important;
}
.multiselect__option {
    min-height: 20px;
    margin: 0px;
    cursor: pointer;
    color: #f5faf2;
    font-size: 10pt;
    font-style: italic;
    padding: 0px;
    border-top: 1px dotted #f5faf2;
    background: rgb(64, 64, 61);
}
.multiselect__option--highlight {
    background: rgb(64, 64, 61);
}
.multiselect__content-wrapper {
    max-height: 300px;
    border: black;
}
.multiselect__single {
    background: rgb(64, 64, 61);
    color: #f5faf2;
}
.multiselect__input {
    background: rgb(64, 64, 61);
    color: #f5faf2;
}
.multiselect--disabled {
    background: rgb(64, 64, 61);
}
.multiselect-enter-active
 {
    -webkit-transition: max-height 1s ease;
    -o-transition: max-height 1s ease;
    transition: max-height 1s ease;
    overflow: hidden;
}
.multiselect-enter,
.multiselect-leave-active {
    max-height: 0px !important;
    overflow: hidden;
}
.multiselect-leave-active {
    -webkit-transition: max-height 0.1s ease;
    -o-transition: max-height 0.1s ease;
    transition: max-height 0.1s ease;
}
.multiselect-enter-to {
    max-height: 300px;
}
.multiselect-leave-to {
    max-height: 0px;
}
</style>
