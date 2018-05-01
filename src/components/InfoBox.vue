<template>
    <div>
        <div class="label environment-info">
            {{ info }} 
        </div>

        <span v-if="info!=''">
            <div class="species-info-box" style="margin-top: 15px; width: 700px; position: relative; z-index: 10000;">
                <div style="" class="info-box-image environment-image"></div>  
                <div class="label info-box-info">
                    Here is some information about this environment layer. For example, where it encompasses, what categories does it have, how important it is to species in general, etc. 
                </div>
            </div>
            <div class="species-info-toggle" style="margin-left: 80px; margin-top: -12px;">
                <div class="triangle"></div>
            </div>
        </span>
    </div>
</template>
<script>
export default {
    name: "InfoBox",
    props: {
        info:{
            default: "",
            type: String
        }
    },
    mounted: function(){
        this.$root.$on('layerChanged', data =>{
            console.log(data.info);
            this.info= data.info;
        });
    }
}
</script>
