import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["slider", "minInput", "maxInput", "minLabel", "maxLabel"]

  connect() {
    const slider = this.sliderTarget
    
    noUiSlider.create(slider, {
      start: [
        parseInt(this.minInputTarget.value) || slider.dataset.defaultMin,
        parseInt(this.maxInputTarget.value) || slider.dataset.defaultMax
      ],
      connect: true,
      step: parseInt(slider.dataset.step),
      range: {
        'min': parseInt(slider.dataset.min),
        'max': parseInt(slider.dataset.max)
      }
    })

    slider.noUiSlider.on('update', (values) => {
      const [min, max] = values.map(value => parseInt(value))
      
      this.minInputTarget.value = min
      this.maxInputTarget.value = max
      
      this.minLabelTarget.textContent = `$${min}`
      this.maxLabelTarget.textContent = `$${max}`
    })
  }
} 
