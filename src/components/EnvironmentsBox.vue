<template>
	<div class='box' style="border: none;">
		<div class='label'>1. Select an environmental attribute</div>
		<select v-model="selected" v-on:change="layerChanged">
			<option value="" disabled selected>Select an environment layer</option>
			<option v-for="(item, key, index) in layers" :value="key">
				{{ item.name }}
			</option>
		</select>      
		<InfoBox></InfoBox>
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
            layers: {}, 
            selected: ""
        }
    },
    methods: {
        layerChanged: function(){
            this.$root.$emit('layerChanged', this.$data.layers[this.$data.selected], 
                this.$data.selected);
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
                self.layers = (data);
            }
        });
    }
}
</script>
