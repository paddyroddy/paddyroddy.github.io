---
---

tsParticles
  .loadJSON("tsparticles", "{{ '/assets/json/particles.json' | relative_url }}")
  .then((container) => {
    console.log("callback - tsparticles config loaded");
  })
  .catch((error) => {
    console.error(error);
  });
