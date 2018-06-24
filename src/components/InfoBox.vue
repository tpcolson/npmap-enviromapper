<template>
    <div>
        <div class="label environment-info">
            {{ mutableInfo }} 
        </div>

        <span style="display: block;" v-if="subcatName1 !== '' || subcatName2 !== ''">
            <transition name="info-slide">
            <div v-if="open" class="species-info-box">
                <div class="info-box-title">{{ subcatName1 }}</div>
                <div style="" class="info-box-image environment-image"><img v-if="subcatImg1 !== ''" :src="subcatImg1" /></div>  
                <div class="info-box-info" v-if="subcatInfo1 !== ''">{{ subcatInfo1 }}</div>
            </div>
            </transition>
            <div @click="open=!open" class="species-info-toggle" style="margin-left: 200px; margin-top: 0px;">
                <div :class="{ 'triangle-closed': !open, 'triangle-open': open }" class="triangle"></div>
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
        },
        layer: {
            type: Object
        }
    },
    data: function() {
        return {
            open: false,
            mutableInfo: this.info,
            subcatName1: '',
            subcatName2: '',
            subcatImg1: '',
            subcatImg2: '',
            subcatInfo1: '',
            subcatInfo2: ''
        }
    },
    mounted: function(){
        this.$root.$on('layerChanged', data =>{
            this.mutableInfo = data.info;
        });
        this.$root.$on('subcatChanged', (subcatName, subcatNumber) => {
            let name = subcatName;
            if (subcatNumber == 1) {
                if (name == 'null') {
                    name = '';
                }
                this.subcatName1 = name;
                if (this.layer != undefined) {
                    let subcat = this.layer.subcategories;
                    for (let key in subcat) {
                        if (subcatName == subcat[key].name) {
                            this.subcatImg1 = subcat[key].img;
                            this.subcatInfo1 = subcat[key].info;
                        }
                    }
                }
            }
            if (subcatNumber == 2) {
                if (subcatName == 'null') {
                    name = '';
                }
                this.subcatName2 = name;
                if (this.layer != undefined) {
                    let subcat = this.layer.subcategories;
                    for (let key in subcat) {
                        if (subcatName == subcat[key].name) {
                            this.subcatImg2 = subcat[key].img;
                            this.subcatInfo2 = subcat[key].info;
                        }
                    }
                }
            }
            
        });
    },
    watch: {
        info: function() {
            this.mutableInfo = this.info;
        }
    }
}
</script>

<style>
.info-box-title {
    font-weight: bold;
    border-bottom: 5px solid magenta;
    width: 100px;
    padding: 10px;
    margin-bottom: 10px;
}
.info-box-image {
    text-align: center;
}
.species-info-box {
    background-color: #EAEAEA;
    width: 470px; 
    height: 300px;
    position: relative; 
    z-index: 10000;
    color: #333;
    box-shadow: 0 0 5px #777, inset 0 6px 3px -5px #777;
    border: 1px solid #999;
    border-top: 0;
}
.info-slide-enter {
    height: 0;
}
.info-slide-enter-to {
    transition: height 1s ease-out;
    height: 300px;
}
.info-slide-leave-to {
    height: 0;
    transition: height 1s ease-out;
}
.triangle-closed {
    transform: rotate(0deg);
    transition: transform 1s ease-out;
}
.triangle-open {
    transform: rotate(180deg);
    transition: transform 1s ease-out;
}

</style>
