using UnityEngine;

public class VFXTrigger : MonoBehaviour
{
	public GameObject VFXPrefab;
	public Transform VFXPivot;

	public void SpawnVFX ()
	{
		Instantiate (VFXPrefab, VFXPivot.position, VFXPrefab.transform.rotation);
	}
}