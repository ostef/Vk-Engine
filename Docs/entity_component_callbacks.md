| Name | State | Called On | When | Usage |
|----|----|----|----|----|
| `OnCreate` | Editor & Game | Entities & Components | Right after the entity or component has been created but before it has been deserialized | Create mandatory components and eventually load assets, less commonly allocate memory for serializable data |
| `OnDestroy` | Editor & Game | Entities & Components | Right before the entity is deallocated and removed from by name and by guid maps, after removing it from the entity hierarchy | Destroy components and unload assets, free memory |
| `OnSpawn` | Game | Entities & Components | Upon level load, called after all the entities have been created and deserialized. When spawning an entity during the game, called right after OnCreate. We might provide a way to bulk spawn entities, and call OnSpawn after all were created. | Game related initialization that needs to access other components or other entities |
| `OnKilled` | Game | Entities & Components | The first time KillEntity is called on the entity. Not called when the world gets destroyed if the entity is still alive | Spawning things like particle effects when an entity is killed |
| `OnComponentAdded` | Game | Entities & Components | When a component is added to the entity |
| `OnComponentRemoved` | Game | Entities & Components | When a component is removed from the entity |
| `OnAttached` | Game | Entities | After the entity was attached to another entity |
| `OnDetach` | Game | Entities | Before the entity is detached from its parent |
| `OnUpdate` | Game | Entities & Components | When updating the world. All entities in the world are updated first, then all components. The update happens by entity/component type |
| `OnEditorUpdate` | Editor | Entities & Components | When updating the world inside the editor. All entities in the world are updated first, then all components |
| `OnEditorModified` | Editor | Entities & Components | When an entity or component is modified in the editor |
| `OnDebugDraw` | Editor & Game | Entities & Components | When debug drawing is enabled |
| `OnDebugDrawSelected` | Editor & Game | Entities & Components | When debug drawing is enabled, and the entity is selected |
