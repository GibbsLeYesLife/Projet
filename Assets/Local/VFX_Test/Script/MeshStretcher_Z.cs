using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MeshStretcher_Z : MonoBehaviour 
{
    [SerializeField] private Transform quadObject;

    [SerializeField] private Transform start;
    [SerializeField] private Transform end;
    [SerializeField] private Transform targetPosition;

    [Range(0, 1)]
    [SerializeField] private float rayJourney = 0.0f;

    private void Start() 
    {
        SetPos(start.position, end.position);
    }

    private void OnEnable ()
    {
        end.position = start.position;
        SetPos(start.position, end.position);
    }

    private void Update () 
    {
        end.position = Vector3.Lerp (start.position, targetPosition.position, rayJourney);
        SetPos(start.position, end.position);
    }

    private void SetPos(Vector3 start, Vector3 end) 
    {
        var dir = end - start;
        var mid = (dir) / 2.0f + start;
        quadObject.position = mid;
        quadObject.rotation = Quaternion.FromToRotation(Vector3.up, dir);
        Vector3 scale = quadObject.localScale;
        scale.z = dir.magnitude;
        quadObject.localScale = scale;
    }
}
